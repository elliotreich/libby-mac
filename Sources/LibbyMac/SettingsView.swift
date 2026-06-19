import SwiftUI

struct SettingsView: View {
    @ObservedObject var transcript: TranscriptManager
    @ObservedObject var hotkeys: HotKeyManager

    var body: some View {
        Form {
            Section("Global Shortcuts") {
                Text("Option+Shift+5: rewind 5 seconds")
                Text("Option+Shift+0: rewind 10 seconds")
                Text("Option+Shift+9: rewind 15 seconds")
            }

            Section("Transcript") {
                Text("Transcript uses Speech Recognition + Microphone permissions.")
                Text("This listens to audible audio and is best-effort only.")
            }
        }
        .padding()
        .frame(width: 520, height: 220)
    }
}
