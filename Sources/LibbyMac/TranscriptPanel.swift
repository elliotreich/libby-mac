import SwiftUI

struct TranscriptPanel: View {
    @ObservedObject var webModel: WebViewModel
    @ObservedObject var transcript: TranscriptManager

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Transcript (Beta)")
                    .font(.headline)
                Spacer()
                Button(transcript.isListening ? "Stop" : "Start") {
                    Task {
                        if !transcript.isListening {
                            await transcript.requestPermissions()
                        }
                        transcript.toggleListening()
                    }
                }
                .buttonStyle(.borderedProminent)
            }

            Text("Uses your microphone to capture currently audible speech. Not an official Libby transcript.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(transcript.status)
                .font(.caption)
                .foregroundStyle(.secondary)

            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(transcript.lines.suffix(12)) { line in
                        HStack(alignment: .top, spacing: 8) {
                            Button(format(seconds: line.secondsFromStart)) {
                                webModel.rewind(seconds: 10)
                            }
                            .font(.caption.monospacedDigit())
                            .buttonStyle(.borderless)

                            Text(line.text)
                                .font(.caption)
                                .textSelection(.enabled)
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
    }

    private func format(seconds: TimeInterval) -> String {
        let value = Int(seconds)
        let minutes = value / 60
        let remainder = value % 60
        return String(format: "%02d:%02d", minutes, remainder)
    }
}
