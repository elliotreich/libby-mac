import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}

@main
struct LibbyMacApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var webModel = WebViewModel()
    @StateObject private var transcript = TranscriptManager()
    @StateObject private var hotkeys = HotKeyManager()
    @StateObject private var settings = SettingsStore()

    var body: some Scene {
        MenuBarExtra("Libby", systemImage: "books.vertical") {
            MenuBarView(webModel: webModel, transcript: transcript, settings: settings)
                .onAppear {
                    hotkeys.configure(webModel: webModel)
                }
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView(transcript: transcript, hotkeys: hotkeys, settings: settings)
        }
    }
}
