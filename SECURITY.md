# Security Policy

## Scope

`depalma` is a niche macOS utility that:

- requires `Accessibility`
- requires `Input Monitoring`
- uses a private Touch Bar API surface
- intentionally intercepts and suppresses click events while enabled
- does not use network services or a privileged helper
- does not register itself as a login item

If that trust model is not acceptable for your environment, do not run it.

## Supported Build Path

The only supported build path is:

```bash
./build.sh
```

Older exploratory scripts and alternate build paths were removed on purpose.

## Reporting

If you find a security issue in the current code, open a GitHub issue or a GitHub security advisory on this repository.

Please include:

- macOS version
- whether the app was ad hoc signed or signed with `DEPALMA_CODESIGN_IDENTITY`
- exact reproduction steps
- whether the issue affects click filtering, permissions, persistence, or packaging

## Operational Safety

- fresh launch starts with Click Guard off
- sleep and wake force Click Guard off
- quit forces Click Guard off
- login startup is user-controlled through macOS Login Items

## Non-Goals

This project does not claim to be:

- a hardened security product
- a general-purpose input sandbox
- a full trackpad-disable utility
