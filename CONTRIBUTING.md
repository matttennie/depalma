# Contributing

`depalma` is intentionally narrow.

Before sending changes:

- keep the scope on click blocking, permissions, packaging, and Touch Bar integration
- do not add network services, telemetry, analytics, or background helpers
- do not add root-only tooling or hidden persistence
- keep docs aligned with observed behavior on current macOS
- prefer removing confusing code over carrying legacy experiments forward

## Build And Test

```bash
./build.sh
```

That path runs the current tests before building the app bundle. The build script auto-detects an Apple Development certificate for signing. If you do not have one, the app will be ad hoc signed and TCC permissions will not persist across reboots.

## Review Standard

Changes should be easy to audit:

- one supported build path
- explicit permission requirements
- no surprise auto-start behavior
- no claims beyond what the code and current macOS behavior actually prove

## Provenance

This repository is maintained by Matthew Tennie.
The implementation is current local work, informed by prior public experimentation around click blocking on macOS.
