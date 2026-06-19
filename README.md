# LibbyMenuBar (macOS)

A native macOS menu bar wrapper for Libby audiobook playback.

## Included now

- Menu bar app (`MenuBarExtra`) with compact player popover.
- Embedded Libby web app (`https://libbyapp.com`) with persistent login/session.
- Quick rewind controls (`-5s`, `-10s`, `-15s`).
- Global shortcuts (work while you are in other full-screen apps):
  - `Option+Shift+5`: rewind 5s
  - `Option+Shift+0`: rewind 10s
  - `Option+Shift+9`: rewind 15s
- Transcript panel (beta): live speech-to-text from microphone with timestamps.

## Important transcript note

Libby does not generally provide a built-in full transcript for audiobooks.

This app's transcript mode is a best-effort live capture using your Mac microphone and Apple's Speech Recognition APIs. It's useful for "what did I just hear?" moments, but it is not guaranteed to be exact.

## Open and run

1. Open `/Users/elliot.reich/MEGA/Projects/libby-mac/Package.swift` in Xcode.
2. Run the `LibbyMac` scheme.
3. Click the menu bar icon (`books.vertical`) to open the compact player.

## Required macOS privacy keys for transcript feature

Before using `Transcript (Beta)`, add these keys to your app target's `Info.plist` in Xcode:

- `NSSpeechRecognitionUsageDescription`
- `NSMicrophoneUsageDescription`

Example values:

- `NSSpeechRecognitionUsageDescription`: `Transcribe currently playing audiobook audio into short, timestamped notes.`
- `NSMicrophoneUsageDescription`: `Capture audio for live transcript while listening.`

Without these keys, macOS speech/mic permission requests can fail or crash.

## Distribution

To install as an app on your Mac:

1. In Xcode: `Product` -> `Archive`
2. Organizer: `Distribute App` -> `Copy App`

