import SwiftUI

struct MenuBarView: View {
    @ObservedObject var webModel: WebViewModel
    @ObservedObject var transcript: TranscriptManager
    @ObservedObject var settings: SettingsStore

    var body: some View {
        VStack(spacing: 0) {
            // Header with controls
            headerView
                .padding(.horizontal, 12)
                .padding(.top, 10)
                .padding(.bottom, 8)

            Divider()
                .background(Color.white.opacity(0.1))

            // Web view
            LibbyWebView(model: webModel)
                .frame(width: settings.windowWidth, height: settings.webViewHeight)

            // Transcript panel (conditionally shown)
            if settings.showTranscript {
                Divider()
                    .background(Color.white.opacity(0.1))
                TranscriptPanel(webModel: webModel, transcript: transcript)
                    .frame(width: settings.windowWidth, height: settings.transcriptHeight)
            }

            // Footer with quit
            Divider()
                .background(Color.white.opacity(0.1))

            footerView
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
        }
        .frame(width: settings.windowWidth)
        .background(Color.black)
        .preferredColorScheme(.dark)
    }

    private var headerView: some View {
        HStack(spacing: 8) {
            // Rewind buttons (only show enabled ones)
            rewindButtons

            Divider()
                .frame(height: 20)
                .background(Color.white.opacity(0.15))

            // Play/Pause
            Button(action: webModel.togglePlayPause) {
                Image(systemName: "playpause.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            .buttonStyle(.plain)

            Spacer()

            // Reload
            Button(action: webModel.reload) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            .buttonStyle(.plain)

            // Open in browser
            Button("Open") {
                webModel.openInDefaultBrowser()
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.white.opacity(0.7))
            .buttonStyle(.plain)
        }
    }

    private var rewindButtons: some View {
        HStack(spacing: 6) {
            if settings.rewind5Enabled {
                rewindButton("-5s", seconds: 5)
            }
            if settings.rewind10Enabled {
                rewindButton("-10s", seconds: 10)
            }
            if settings.rewind15Enabled {
                rewindButton("-15s", seconds: 15)
            }
        }
    }

    private func rewindButton(_ label: String, seconds: Int) -> some View {
        Button(label) { webModel.rewind(seconds: seconds) }
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
            )
    }

    private var footerView: some View {
        HStack {
            // Settings gear
            Button {
                NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.5))
            }
            .buttonStyle(.plain)
            .help("Settings")

            Spacer()

            // Quit button
            Button("Quit LibbyMac") {
                NSApplication.shared.terminate(nil)
            }
            .font(.system(size: 12))
            .foregroundColor(.white.opacity(0.4))
            .buttonStyle(.plain)
        }
    }
}
