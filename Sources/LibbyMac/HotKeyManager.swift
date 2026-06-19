import Carbon
import Combine
import Foundation

@MainActor
final class HotKeyManager: ObservableObject {
    @Published var status = "Global shortcuts active: Option+Shift+5/0/9"

    private weak var webModel: WebViewModel?
    private var hotKeyRefs: [EventHotKeyRef?] = []

    private enum HotKeyID: UInt32 {
        case rewind5 = 1
        case rewind10 = 2
        case rewind15 = 3
    }

    func configure(webModel: WebViewModel) {
        self.webModel = webModel
        guard hotKeyRefs.isEmpty else { return }
        registerHotKeys()
        installHandlerIfNeeded()
    }

    private func registerHotKeys() {
        hotKeyRefs.append(register(id: .rewind5, keyCode: UInt32(kVK_ANSI_5)))
        hotKeyRefs.append(register(id: .rewind10, keyCode: UInt32(kVK_ANSI_0)))
        hotKeyRefs.append(register(id: .rewind15, keyCode: UInt32(kVK_ANSI_9)))
    }

    private func register(id: HotKeyID, keyCode: UInt32) -> EventHotKeyRef? {
        var ref: EventHotKeyRef?
        let hotKeyID = EventHotKeyID(signature: fourCharCode("LBYM"), id: id.rawValue)
        let modifiers = UInt32(optionKey) | UInt32(shiftKey)
        RegisterEventHotKey(keyCode, modifiers, hotKeyID, GetApplicationEventTarget(), 0, &ref)
        return ref
    }

    private func installHandlerIfNeeded() {
        struct HandlerState {
            static var installed = false
        }
        guard !HandlerState.installed else { return }

        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))

        InstallEventHandler(
            GetApplicationEventTarget(),
            { _, eventRef, _ in
                var hotKeyID = EventHotKeyID()
                let status = GetEventParameter(
                    eventRef,
                    EventParamName(kEventParamDirectObject),
                    EventParamType(typeEventHotKeyID),
                    nil,
                    MemoryLayout<EventHotKeyID>.size,
                    nil,
                    &hotKeyID
                )
                guard status == noErr else { return noErr }

                Task { @MainActor in
                    AppServices.shared.handle(hotKeyID: hotKeyID)
                }
                return noErr
            },
            1,
            &eventType,
            nil,
            nil
        )

        HandlerState.installed = true
    }

    private func fourCharCode(_ string: String) -> UInt32 {
        string.utf8.reduce(0) { ($0 << 8) + UInt32($1) }
    }
}

@MainActor
final class AppServices {
    static let shared = AppServices()

    weak var webModel: WebViewModel?

    func bind(webModel: WebViewModel) {
        self.webModel = webModel
    }

    func handle(hotKeyID: EventHotKeyID) {
        switch hotKeyID.id {
        case 1:
            webModel?.rewind(seconds: 5)
        case 2:
            webModel?.rewind(seconds: 10)
        case 3:
            webModel?.rewind(seconds: 15)
        default:
            break
        }
    }
}
