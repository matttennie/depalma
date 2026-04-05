#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$ROOT_DIR/build-app"
CONFIGURATION="debug"
INSTALL_APP=0
RUN_TESTS=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --release)
      CONFIGURATION="release"
      ;;
    --install)
      INSTALL_APP=1
      ;;
    --skip-tests)
      RUN_TESTS=0
      ;;
    --clean)
      rm -rf "$BUILD_DIR" "$ROOT_DIR/.build"
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
  shift
done

if [[ "$RUN_TESTS" -eq 1 ]]; then
  swift test
fi

swift build -c "$CONFIGURATION"
BIN_PATH="$(swift build -c "$CONFIGURATION" --show-bin-path)"

APP_DIR="$BUILD_DIR/Build/Products/${CONFIGURATION:u}/depalma.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

rm -rf "$APP_DIR"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"

cp "$BIN_PATH/depalma" "$MACOS_DIR/depalma"
cp "$ROOT_DIR/Resources/Info.plist" "$CONTENTS_DIR/Info.plist"
cp -R "$ROOT_DIR/Resources/Icons" "$RESOURCES_DIR/Icons"

IDENTITY="${DEPALMA_CODESIGN_IDENTITY:-}"
if [[ -n "$IDENTITY" ]]; then
  echo "Signing with: $IDENTITY"
  codesign --force --deep --sign "$IDENTITY" "$APP_DIR"
else
  echo "Signing ad hoc"
  codesign --force --deep --sign - "$APP_DIR"
fi

echo "Built app:"
echo "$APP_DIR"

if [[ "$INSTALL_APP" -eq 1 ]]; then
  rm -rf /Applications/depalma.app
  cp -R "$APP_DIR" /Applications/depalma.app
  echo "Installed app:"
  echo "/Applications/depalma.app"
fi
