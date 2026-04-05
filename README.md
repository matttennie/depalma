# depalma

depalma is a small macOS menu bar and Touch Bar utility that blocks click events while it is on. Pointer movement still works. Keyboard input is untouched.

It exists for the specific case where accidental trackpad taps or clicks steal focus while you are typing.

Inspired by [TouchGuard](https://github.com/thesyntaxinator/TouchGuard) by [Prag](https://github.com/thesyntaxinator).
Current fork and depalma adaptation by Matthew Tennie.

This is a narrow macOS utility for people who are comfortable building local code, granting `Accessibility` and `Input Monitoring`, and accepting that it relies on private Touch Bar APIs. It is not positioned as a polished or broadly supported end-user app.

## What It Does

- `On`: blocks left, right, and other mouse click down/up events
- `Off`: allows clicks normally
- does not block pointer movement
- does not block keyboard input

| State | Icon | Function |
| --- | --- | --- |
| Off | <img src="Resources/Icons/depalma_off.png" alt="depalma off icon" width="18"> | clicks work normally |
| On | <img src="Resources/Icons/depalma_on.png" alt="depalma on icon" width="18"> | clicks are blocked |

## Build

```bash
./build.sh
```

The built app lands at:

```bash
build-app/Build/Products/DEBUG/depalma.app
```

To install it to `/Applications`:

```bash
./build.sh --install
```

To sign with your own Apple Development identity instead of ad hoc signing:

```bash
DEPALMA_CODESIGN_IDENTITY="Apple Development: Your Name (TEAMID)" ./build.sh --install
```

## First Run

depalma needs:

- `Accessibility`
- `Input Monitoring`

Grant both to `/Applications/depalma.app` if macOS prompts.

If you want it available at login, open Login Items and add `/Applications/depalma.app` yourself:

```bash
open "x-apple.systempreferences:com.apple.LoginItems-Settings.extension"
```

## Use

- tap the Touch Bar button or use the menu bar item to toggle Click Guard
- when Click Guard is on, clicks are blocked
- when Click Guard is off, clicks work normally
- when the Mac sleeps or wakes, Click Guard is forced off
- on a fresh launch, login, or reboot, depalma starts with Click Guard off

## Notes

- this is a click blocker, not a full trackpad disable tool
- if macOS cannot distinguish your devices at the event-tap level, external mouse clicks may also be blocked while Click Guard is on
- the repo supports the Swift package build path documented above; older exploratory tooling was removed on purpose

## Project Files

- [AUTHORS.md](AUTHORS.md)
- [LICENSE](LICENSE)
- [SECURITY.md](SECURITY.md)
