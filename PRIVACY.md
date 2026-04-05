# Privacy

`depalma` is a local-only utility.

## What It Accesses

- `Accessibility`, so it can filter click events
- `Input Monitoring`, so it can observe the click stream

## What It Does Not Do

- no network access by design
- no telemetry
- no analytics
- no crash reporting service
- no cloud sync
- no hidden login item registration
- no privileged helper

## Local State

`depalma` does not store click history or usage logs.

The app state is in-memory only:

- Click Guard starts off on fresh launch
- Click Guard is forced off on sleep and wake
- Click Guard is forced off on quit

If you add `depalma` to Login Items, that startup behavior is still under your control in macOS settings.
