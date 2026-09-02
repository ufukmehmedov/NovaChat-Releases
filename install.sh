#!/usr/bin/env bash
set -euo pipefail

REPO="ufukmehmedov/NovaChat-Releases"
RAW_BASE="https://raw.githubusercontent.com/$REPO/main"
RELEASE_BASE="https://github.com/$REPO/releases/download"
META_URL="$RAW_BASE/bootstrap-release.txt"

need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "NovaChat installer requires '$1'." >&2
    exit 1
  }
}

need curl
need unzip

TMP="$(mktemp -d)"
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

META="$TMP/bootstrap-release.txt"
curl -fsSL "$META_URL" -o "$META"

meta_value() {
  local key="$1"
  sed -n "s/^${key}=//p" "$META" | head -n1
}

TAG="$(meta_value TAG)"
ASSET="$(meta_value LINUX_ASSET)"
EXPECTED_SHA="$(meta_value LINUX_SHA256 | tr '[:upper:]' '[:lower:]')"

[[ "$TAG" =~ ^v[0-9A-Za-z._-]+$ ]] || { echo "Invalid release tag." >&2; exit 1; }
[[ "$ASSET" =~ ^NovaChat_Linux_[0-9A-Za-z._-]+\.zip$ ]] || { echo "Invalid Linux asset name." >&2; exit 1; }
[[ "$EXPECTED_SHA" =~ ^[0-9a-f]{64}$ ]] || { echo "Invalid Linux SHA-256." >&2; exit 1; }

case "$(uname -m)" in
  x86_64|amd64) ;;
  *) echo "NovaChat Linux currently supports x86_64/amd64 only." >&2; exit 1 ;;
esac

ZIP="$TMP/$ASSET"
URL="$RELEASE_BASE/$TAG/$ASSET"
echo "Downloading NovaChat $TAG..."
curl -fL --retry 3 --connect-timeout 15 "$URL" -o "$ZIP"

if command -v sha256sum >/dev/null 2>&1; then
  ACTUAL_SHA="$(sha256sum "$ZIP" | awk '{print $1}')"
elif command -v shasum >/dev/null 2>&1; then
  ACTUAL_SHA="$(shasum -a 256 "$ZIP" | awk '{print $1}')"
else
  echo "NovaChat installer requires sha256sum or shasum." >&2
  exit 1
fi
ACTUAL_SHA="$(printf '%s' "$ACTUAL_SHA" | tr '[:upper:]' '[:lower:]')"

if [[ "$ACTUAL_SHA" != "$EXPECTED_SHA" ]]; then
  echo "SHA-256 verification failed. Installation stopped." >&2
  exit 1
fi

echo "SHA-256 verified."
PKG="$TMP/package"
mkdir -p "$PKG"
unzip -q "$ZIP" -d "$PKG"

INSTALLER="$PKG/INSTALL_LINUX.sh"
[[ -f "$INSTALLER" ]] || { echo "INSTALL_LINUX.sh not found in package." >&2; exit 1; }
chmod +x "$INSTALLER"
"$INSTALLER"

echo
echo "NovaChat installation complete. Start it with: novachat"
