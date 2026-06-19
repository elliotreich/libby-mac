import AppKit
import Foundation
import SwiftUI
import WebKit

@MainActor
final class WebViewModel: NSObject, ObservableObject {
    @Published var canGoBack = false
    @Published var canGoForward = false

    private weak var webView: WKWebView?
    private let libbyURL = URL(string: "https://libbyapp.com")!

    func bind(_ webView: WKWebView) {
        self.webView = webView
        AppServices.shared.bind(webModel: self)
        updateNavState(webView)
    }

    func loadIfNeeded(_ webView: WKWebView) {
        if webView.url == nil {
            let request = URLRequest(url: libbyURL)
            webView.load(request)
        }
    }

    func goBack() { webView?.goBack() }
    func goForward() { webView?.goForward() }
    func reload() { webView?.reload() }

    func openInDefaultBrowser() {
        let url = webView?.url ?? libbyURL
        NSWorkspace.shared.open(url)
    }

    func rewind(seconds: Int) {
        let js = """
        (() => {
          const media = document.querySelector('audio, video');
          if (!media || Number.isNaN(media.currentTime)) return 'no-media';
          media.currentTime = Math.max(0, media.currentTime - \(seconds));
          return 'ok';
        })();
        """
        webView?.evaluateJavaScript(js)
    }

    func togglePlayPause() {
        let js = """
        (() => {
          const media = document.querySelector('audio, video');
          if (!media) return 'no-media';
          if (media.paused) { media.play(); return 'play'; }
          media.pause();
          return 'pause';
        })();
        """
        webView?.evaluateJavaScript(js)
    }

    func updateNavState(_ webView: WKWebView) {
        canGoBack = webView.canGoBack
        canGoForward = webView.canGoForward
    }
}

struct LibbyWebView: NSViewRepresentable {
    @ObservedObject var model: WebViewModel

    func makeCoordinator() -> Coordinator {
        Coordinator(model: model)
    }

    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.allowsAirPlayForMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator

        model.bind(webView)
        model.loadIfNeeded(webView)

        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        model.bind(webView)
    }

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        private let model: WebViewModel

        init(model: WebViewModel) {
            self.model = model
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            model.updateNavState(webView)
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            model.updateNavState(webView)
        }

        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            webView.reload()
        }

        func webView(
            _ webView: WKWebView,
            createWebViewWith configuration: WKWebViewConfiguration,
            for navigationAction: WKNavigationAction,
            windowFeatures: WKWindowFeatures
        ) -> WKWebView? {
            if let url = navigationAction.request.url {
                NSWorkspace.shared.open(url)
            }
            return nil
        }
    }
}
