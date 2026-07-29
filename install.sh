#!/usr/bin/env bash
#
# install.sh — Download and install the latest Beacon.app release for this Mac.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/quizuncle/beacon-releases/HEAD/install.sh | bash
#
# What it does:
#   1. Detects your Mac's chip (Apple Silicon vs Intel) via `uname -m`.
#   2. Downloads the matching DMG from this repo's latest GitHub Release.
#   3. Mounts it, copies Beacon.app into /Applications, unmounts.
#   4. Clears the macOS quarantine flag (`xattr -cr`) so Beacon opens without the
#      "unidentified developer" warning — see the README for why this is needed
#      for an unsigned, non-notarized indie app.
#
set -euo pipefail

REPO="quizuncle/beacon-releases"
APP_NAME="Beacon.app"
INSTALL_DIR="/Applications"

echo "==> Detecting Mac architecture..."
ARCH="$(uname -m)"
if [[ "$ARCH" == "arm64" ]]; then
  echo "    Apple Silicon (arm64) detected."
else
  echo "    Intel (x86_64) detected."
fi

echo "==> Finding the latest release..."
LATEST_JSON="$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest")"

# Every .dmg asset URL in the release, one per line.
ALL_DMG_URLS="$(echo "$LATEST_JSON" | grep -o '"browser_download_url": *"[^"]*\.dmg"' | sed -E 's/.*"(https[^"]+)"/\1/')"

# Pick the arm64 build for Apple Silicon, or the one non-arm64 build for Intel.
if [[ "$ARCH" == "arm64" ]]; then
  DMG_URL="$(echo "$ALL_DMG_URLS" | grep 'arm64' | head -1)"
else
  DMG_URL="$(echo "$ALL_DMG_URLS" | grep -v 'arm64' | head -1)"
fi

if [[ -z "$DMG_URL" ]]; then
  echo "!! Could not find a matching DMG in the latest release. Download manually from:" >&2
  echo "   https://github.com/${REPO}/releases/latest" >&2
  exit 1
fi

echo "    Latest build: $DMG_URL"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
DMG_PATH="$TMP_DIR/Beacon.dmg"

echo "==> Downloading..."
curl -fsSL -o "$DMG_PATH" "$DMG_URL"

echo "==> Mounting..."
MOUNT_POINT="$(hdiutil attach "$DMG_PATH" -nobrowse -noautoopen | tail -1 | awk -F '\t' '{print $3}')"
if [[ -z "$MOUNT_POINT" ]]; then
  echo "!! Failed to mount the DMG." >&2
  exit 1
fi

echo "==> Installing to ${INSTALL_DIR}..."
if [[ -d "${INSTALL_DIR}/${APP_NAME}" ]]; then
  echo "    Removing previous version..."
  rm -rf "${INSTALL_DIR:?}/${APP_NAME}"
fi
cp -R "${MOUNT_POINT}/${APP_NAME}" "${INSTALL_DIR}/"

echo "==> Unmounting..."
hdiutil detach "$MOUNT_POINT" -quiet

echo "==> Clearing the Gatekeeper quarantine flag..."
xattr -cr "${INSTALL_DIR}/${APP_NAME}"

echo ""
echo "✓ Beacon installed to ${INSTALL_DIR}/${APP_NAME}"
echo "  Launch it from Applications, Spotlight, or:  open '${INSTALL_DIR}/${APP_NAME}'"
