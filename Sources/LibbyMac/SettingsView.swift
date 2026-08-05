import SwiftUI

struct SettingsView: View {
    @ObservedObject var transcript: TranscriptManager
    @ObservedObject var hotkeys: HotKeyManager
    @ObservedObject var settings: SettingsStore

    var body: some View {
        Form {
            Section("Rewind Buttons") {
                Toggle("Show -5s", isOn: $settings.rewind5Enabled)
                    .onChange(of: settings.rewind5Enabled) { _ in settings.save() }
                Toggle("Show -10s", isOn: $settings.rewind10Enabled)
                    .onChange(of: settings.rewind10Enabled) { _ in settings.save() }
                Toggle("Show -15s", isOn: $settings.rewind15Enabled)
                    .onChange(of: settings.rewind15Enabled) { _ in settings.save() }
            }

            Section("Transcript") {
                Toggle("Show Transcript Panel", isOn: $settings.showTranscript)
                    .onChange(of: settings.showTranscript) { _ in settings.save() }
                Text("Transcript uses Speech Recognition + Microphone permissions.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("This listens to audible audio and is best-effort only.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Global Shortcuts") {
                Text("Option+Shift+5: rewind 5 seconds")
                Text("Option+Shift+0: rewind 10 seconds")
                Text("Option+Shift+9: rewind 15 seconds")
            }

            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Source")
                    Spacer()
                    Text("github.com/elliotreich/libby-mac")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 520, height: 400)
        .background(Color.black)
        .preferredColorScheme(.dark)
        .scrollContentBackground(.hidden)
    }
}
