import SwiftUI

struct MenuBarView: View {
    @ObservedObject var webModel: WebViewModel
    @ObservedObject var transcript: TranscriptManager

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Button("-5s") { webModel.rewind(seconds: 5) }
                Button("-10s") { webModel.rewind(seconds: 10) }
                Button("-15s") { webModel.rewind(seconds: 15) }

                Divider()
                    .frame(height: 18)

                Button(action: webModel.togglePlayPause) {
                    Image(systemName: "playpause")
                }

                Spacer()

                Button(action: webModel.reload) {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(.borderless)

                Button("Open") {
                    webModel.openInDefaultBrowser()
                }
                .buttonStyle(.borderless)
            }
            .padding(.horizontal, 10)
            .padding(.top, 8)

            LibbyWebView(model: webModel)
                .frame(width: 420, height: 280)

            TranscriptPanel(webModel: webModel, transcript: transcript)
                .frame(width: 420, height: 170)
        }
        .frame(width: 420)
    }
}
