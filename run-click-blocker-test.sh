#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$ROOT_DIR/build"
BIN="$BIN_DIR/TouchGuard"
LOG="$ROOT_DIR/build/click-blocker-test.log"

mkdir -p "$BIN_DIR"

clang \
  -framework ApplicationServices \
  -framework CoreFoundation \
  "$ROOT_DIR/TouchGuard/main.c" \
  -o "$BIN"

echo "Running click blocker test. Press Ctrl+C to stop."
echo "While it is running:"
echo "  - moving the pointer should still work"
echo "  - clicking should be blocked"

sudo "$BIN" 2>&1 | tee "$LOG"
