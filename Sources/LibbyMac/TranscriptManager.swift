import AVFoundation
import Combine
import Foundation
import Speech

struct TranscriptLine: Identifiable {
    let id = UUID()
    let secondsFromStart: TimeInterval
    let text: String
}

final class TranscriptManager: NSObject, ObservableObject {
    @Published var isListening = false
    @Published var status = "Transcript idle"
    @Published var lines: [TranscriptLine] = []

    private let audioEngine = AVAudioEngine()
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var startedAt: Date?

    @MainActor
    func requestPermissions() async {
        let speechAuthorized = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { result in
                continuation.resume(returning: result == .authorized)
            }
        }

        let micAuthorized = await AVCaptureDevice.requestAccess(for: .audio)

        status = speechAuthorized && micAuthorized
            ? "Ready for live transcript"
            : "Mic or speech permission denied"
    }

    @MainActor
    func toggleListening() {
        isListening ? stopListening() : startListening()
    }

    @MainActor
    private func startListening() {
        guard !isListening else { return }
        guard let recognizer, recognizer.isAvailable else {
            status = "Speech recognizer unavailable"
            return
        }

        lines = []
        startedAt = Date()
        status = "Listening via microphone..."

        request = SFSpeechAudioBufferRecognitionRequest()
        request?.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            self?.request?.append(buffer)
        }

        do {
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            status = "Could not start mic: \(error.localizedDescription)"
            cleanup()
            return
        }

        guard let request else {
            status = "Transcript request setup failed"
            cleanup()
            return
        }

        task = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self else { return }
            Task { @MainActor in
                if let result {
                    let text = result.bestTranscription.formattedString.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !text.isEmpty {
                        let elapsed = Date().timeIntervalSince(self.startedAt ?? Date())
                        self.upsertTranscriptLine(text: text, elapsed: elapsed)
                    }
                }

                if let error {
                    self.status = "Transcript error: \(error.localizedDescription)"
                    self.stopListening()
                }
            }
        }

        isListening = true
    }

    @MainActor
    func stopListening() {
        guard isListening else { return }
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        task?.cancel()
        cleanup()
        status = "Transcript paused"
    }

    @MainActor
    private func cleanup() {
        isListening = false
        request = nil
        task = nil
    }

    @MainActor
    private func upsertTranscriptLine(text: String, elapsed: TimeInterval) {
        if let last = lines.last, last.text == text {
            return
        }
        lines.append(TranscriptLine(secondsFromStart: elapsed, text: text))
        if lines.count > 120 {
            lines.removeFirst(lines.count - 120)
        }
    }
}
