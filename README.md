# TouchGuard

TouchGuard is a small macOS menu bar and Touch Bar utility that blocks click events while it is on. Pointer movement still works. Keyboard input is untouched.

It exists for the specific case where accidental trackpad taps or clicks steal focus while you are typing.

Inspired by [TouchGuard](https://github.com/thesyntaxinator/TouchGuard) by [Prag](https://github.com/thesyntaxinator).

## What It Does

- `On`: blocks left, right, and other mouse click down/up events
- `Off`: allows clicks normally
- does not block pointer movement
- does not block keyboard input

| State | Icon | Function |
| --- | --- | --- |
| Off | <img src="Resources/Icons/trackpad_on.png" alt="TouchGuard off icon" width="18"> | clicks work normally |
| On | <img src="Resources/Icons/trackpad_off.png" alt="TouchGuard on icon" width="18"> | clicks are blocked |

## Build

```bash
./build.sh
```

The built app lands at:

```bash
build-app/Build/Products/DEBUG/TouchGuard.app
```

To install it to `/Applications`:

```bash
./build.sh --install
```

## First Run

TouchGuard needs:

- `Accessibility`
- `Input Monitoring`

Grant both to `/Applications/TouchGuard.app` if macOS prompts.

## Use

- tap the Touch Bar button or use the menu bar item to toggle Click Guard
- when Click Guard is on, clicks are blocked
- when Click Guard is off, clicks work normally
- when the Mac sleeps or wakes, Click Guard is forced off
- on a fresh launch, login, or reboot, TouchGuard starts with Click Guard off

## Notes

- this is a click blocker, not a full trackpad disable tool
- when installed in `/Applications`, TouchGuard registers itself to launch at login by default
- if macOS cannot distinguish your devices at the event-tap level, external mouse clicks may also be blocked while Click Guard is on
