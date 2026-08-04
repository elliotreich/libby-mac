import SwiftUI

struct TranscriptPanel: View {
    @ObservedObject var webModel: WebViewModel
    @ObservedObject var transcript: TranscriptManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Transcript (Beta)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                Button(transcript.isListening ? "Stop" : "Start") {
                    Task {
                        if !transcript.isListening {
                            await transcript.requestPermissions()
                        }
                        transcript.toggleListening()
                    }
                }
                .font(.system(size: 11, weight: .medium))
                .buttonStyle(.borderedProminent)
                .tint(transcript.isListening ? .red : .blue)
            }

            Text("Uses your microphone to capture currently audible speech. Not an official Libby transcript.")
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.4))

            Text(transcript.status)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.5))

            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(transcript.lines.suffix(12)) { line in
                        HStack(alignment: .top, spacing: 8) {
                            Button(format(seconds: line.secondsFromStart)) {
                                webModel.rewind(seconds: 10)
                            }
                            .font(.system(size: 9, weight: .medium, design: .monospaced))
                            .foregroundColor(.white.opacity(0.5))
                            .buttonStyle(.plain)
                            .help("Rewind 10s to this point")

                            Text(line.text)
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.85))
                                .textSelection(.enabled)
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 10)
    }

    private func format(seconds: TimeInterval) -> String {
        let value = Int(seconds)
        let minutes = value / 60
        let remainder = value % 60
        return String(format: "%02d:%02d", minutes, remainder)
    }
}
