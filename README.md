# LibbyMenuBar (macOS)

A native macOS menu bar wrapper for Libby audiobook playback.

LibbyMenuBar is a compact `MenuBarExtra` app that embeds the Libby web app (`https://libbyapp.com`) with persistent login, quick rewind, global hotkeys, and an optional live transcript.

## Included now

- Menu bar app (`MenuBarExtra`) with compact player popover
- Embedded Libby web app with persistent `WKWebView` session (login persists across launches)
- Quick rewind controls (`-5s`, `-10s`, `-15s`) via `webView.evaluateJavaScript`
- Global shortcuts (work while you are in other full-screen apps):
  - `Option+Shift+5`: rewind 5s
  - `Option+Shift+0`: rewind 10s
  - `Option+Shift+9`: rewind 15s
- Transcript panel (beta): live speech-to-text from microphone with timestamps (Carbon hotkeys + Apple Speech)

## Important transcript note

Libby does not generally provide a built-in full transcript for audiobooks.

This app's transcript mode is a best-effort live capture using your Mac microphone and Apple's Speech Recognition APIs. It's useful for "what did I just hear?" moments, but it is not guaranteed to be exact.

## Requirements

- macOS 13+ (Ventura or later)
- Xcode 16+ or Swift 5.10+
- Active Libby account (via your library)

## Build & Run

```bash
git clone https://github.com/elliotreich/libby-mac.git
cd libby-mac

# Option 1: Xcode (recommended)
open Package.swift
# Select the LibbyMac scheme and Run

# Option 2: SwiftPM
swift build -c release
.build/release/LibbyMac

# Then click the menu bar icon (books.vertical) to open the compact player
```

## Required macOS privacy keys for transcript feature

Before using `Transcript (Beta)`, add these keys to your app target's `Info.plist` in Xcode:

- `NSSpeechRecognitionUsageDescription`
- `NSMicrophoneUsageDescription`

Example values:

- `NSSpeechRecognitionUsageDescription`: `Transcribe currently playing audiobook audio into short, timestamped notes.`
- `NSMicrophoneUsageDescription`: `Capture audio for live transcript while listening.`

Without these keys, macOS speech/mic permission requests can fail or crash.

## Tests

No automated test suite yet. Verification is manual + `swift build`:

```bash
swift build
# launch and check: menu bar appears, Libby login persists, rewind buttons, global hotkeys, transcript panel
```

Logic is thin (hotkey registration, WebView rewind) — future `Tests/` could cover hotkey ID mapping without needing a real Libby session.

## Maintenance

- **Hotkeys:** Carbon `RegisterEventHotKey` in `Sources/LibbyMac/HotKeyManager.swift` — `Option+Shift+5/0/9`. Change `kVK_ANSI_*` there.
- **WebView:** `LibbyWebView.swift` — persistent `WKWebsiteDataStore`, rewind via JS. Update `https://libbyapp.com` URL there if Libby changes.
- **Transcript:** `TranscriptManager.swift` — Apple Speech, requires mic/speech entitlements. Add keys to `Info.plist` as above.
- **Updates:** `git pull && swift build -c release` — no migrations.

## Distribution

To install as an app on your Mac:

1. In Xcode: `Product` → `Archive`
2. Organizer: `Distribute App` → `Copy App`

## License

MIT License — see [LICENSE](LICENSE).

## Acknowledgments

Libby is a service of OverDrive. This is an independent wrapper and is not affiliated with OverDrive.
