import Foundation

@MainActor
final class SettingsStore: ObservableObject {
    @Published var rewind5Enabled = true
    @Published var rewind10Enabled = true
    @Published var rewind15Enabled = true
    @Published var showTranscript = true
    @Published var windowWidth: CGFloat = 420
    @Published var webViewHeight: CGFloat = 280
    @Published var transcriptHeight: CGFloat = 170

    private let defaults = UserDefaults.standard

    init() {
        load()
    }

    func load() {
        // Bool returns false if not set, so we check if key exists
        if defaults.object(forKey: "rewind5Enabled") != nil {
            rewind5Enabled = defaults.bool(forKey: "rewind5Enabled")
        }
        if defaults.object(forKey: "rewind10Enabled") != nil {
            rewind10Enabled = defaults.bool(forKey: "rewind10Enabled")
        }
        if defaults.object(forKey: "rewind15Enabled") != nil {
            rewind15Enabled = defaults.bool(forKey: "rewind15Enabled")
        }
        if defaults.object(forKey: "showTranscript") != nil {
            showTranscript = defaults.bool(forKey: "showTranscript")
        }
        if defaults.object(forKey: "windowWidth") != nil {
            windowWidth = CGFloat(defaults.double(forKey: "windowWidth"))
        }
        if defaults.object(forKey: "webViewHeight") != nil {
            webViewHeight = CGFloat(defaults.double(forKey: "webViewHeight"))
        }
        if defaults.object(forKey: "transcriptHeight") != nil {
            transcriptHeight = CGFloat(defaults.double(forKey: "transcriptHeight"))
        }
    }

    func save() {
        defaults.set(rewind5Enabled, forKey: "rewind5Enabled")
        defaults.set(rewind10Enabled, forKey: "rewind10Enabled")
        defaults.set(rewind15Enabled, forKey: "rewind15Enabled")
        defaults.set(showTranscript, forKey: "showTranscript")
        defaults.set(Double(windowWidth), forKey: "windowWidth")
        defaults.set(Double(webViewHeight), forKey: "webViewHeight")
        defaults.set(Double(transcriptHeight), forKey: "transcriptHeight")
    }
}
