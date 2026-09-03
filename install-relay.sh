#!/usr/bin/env bash
set -euo pipefail

REPO="ufukmehmedov/NovaChat-Releases"
RAW_BASE="https://raw.githubusercontent.com/$REPO/main"
RELEASE_BASE="https://github.com/$REPO/releases/download"
META_URL="$RAW_BASE/bootstrap-release.txt"

fail() {
  echo "NovaRelay installer: $*" >&2
  exit 1
}

need() {
  command -v "$1" >/dev/null 2>&1 || fail "required command '$1' was not found."
}

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  fail "run this installer as root. Recommended command: curl -fsSL $RAW_BASE/install-relay.sh | sudo bash"
fi

case "$(uname -m)" in
  x86_64|amd64) ;;
  *) fail "NovaRelay currently supports x86_64/amd64 Linux only." ;;
esac

need curl
need unzip
need systemctl
need install
need useradd
need getent

PORT="${NOVARELAY_PORT:-}"
if [[ -z "$PORT" ]]; then
  PORT="7777"
  if [[ -r /dev/tty && -w /dev/tty ]]; then
    printf 'NovaRelay TCP port [7777]: ' > /dev/tty
    IFS= read -r entered < /dev/tty || true
    entered="${entered//[[:space:]]/}"
    [[ -n "$entered" ]] && PORT="$entered"
  fi
fi

[[ "$PORT" =~ ^[0-9]+$ ]] || fail "invalid TCP port '$PORT'."
(( PORT >= 1 && PORT <= 65535 )) || fail "TCP port must be between 1 and 65535."

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
ASSET="$(meta_value RELAY_ASSET)"
EXPECTED_SHA="$(meta_value RELAY_SHA256 | tr '[:upper:]' '[:lower:]')"

[[ "$TAG" =~ ^v[0-9A-Za-z._-]+$ ]] || fail "invalid release tag in bootstrap metadata."
[[ "$ASSET" =~ ^NovaRelay_[0-9A-Za-z._-]+_linux_amd64\.zip$ ]] || fail "invalid NovaRelay asset name in bootstrap metadata."
[[ "$EXPECTED_SHA" =~ ^[0-9a-f]{64}$ ]] || fail "invalid NovaRelay SHA-256 in bootstrap metadata."

ZIP="$TMP/$ASSET"
URL="$RELEASE_BASE/$TAG/$ASSET"
echo "Downloading NovaRelay $TAG..."
curl -fL --retry 3 --connect-timeout 15 "$URL" -o "$ZIP"

if command -v sha256sum >/dev/null 2>&1; then
  ACTUAL_SHA="$(sha256sum "$ZIP" | awk '{print $1}')"
elif command -v shasum >/dev/null 2>&1; then
  ACTUAL_SHA="$(shasum -a 256 "$ZIP" | awk '{print $1}')"
else
  fail "sha256sum or shasum is required."
fi
ACTUAL_SHA="$(printf '%s' "$ACTUAL_SHA" | tr '[:upper:]' '[:lower:]')"
[[ "$ACTUAL_SHA" == "$EXPECTED_SHA" ]] || fail "SHA-256 verification failed. Installation stopped."
echo "SHA-256 verified."

PKG="$TMP/package"
mkdir -p "$PKG"
unzip -q "$ZIP" -d "$PKG"
BINARY="$(find "$PKG" -maxdepth 2 -type f -name novarelay -print -quit)"
[[ -n "$BINARY" && -f "$BINARY" ]] || fail "novarelay binary was not found in the release package."

SERVICE_USER="novarelay"
if ! getent group "$SERVICE_USER" >/dev/null 2>&1; then
  groupadd --system "$SERVICE_USER"
fi
if ! getent passwd "$SERVICE_USER" >/dev/null 2>&1; then
  NOLOGIN="$(command -v nologin || true)"
  [[ -n "$NOLOGIN" ]] || NOLOGIN="/usr/sbin/nologin"
  useradd --system --gid "$SERVICE_USER" --home-dir /var/lib/novarelay --shell "$NOLOGIN" "$SERVICE_USER"
fi

INSTALL_DIR="/opt/novarelay/$PORT"
STATE_DIR="/var/lib/novarelay/$PORT"
SERVICE="novarelay-$PORT.service"
UNIT="/etc/systemd/system/$SERVICE"

mkdir -p "$INSTALL_DIR" "$STATE_DIR"
chmod 755 /opt/novarelay "$INSTALL_DIR"
chown root:root /opt/novarelay "$INSTALL_DIR"
chown -R "$SERVICE_USER:$SERVICE_USER" /var/lib/novarelay "$STATE_DIR"
chmod 750 /var/lib/novarelay "$STATE_DIR"

if systemctl is-active --quiet "$SERVICE" 2>/dev/null; then
  echo "Stopping existing $SERVICE before update..."
  systemctl stop "$SERVICE"
fi

install -m 0755 -o root -g root "$BINARY" "$INSTALL_DIR/novarelay"

cat > "$UNIT" <<EOF
[Unit]
Description=NovaRelay TCP relay on port $PORT
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$SERVICE_USER
Group=$SERVICE_USER
WorkingDirectory=$STATE_DIR
ExecStart=$INSTALL_DIR/novarelay -listen 0.0.0.0:$PORT
Restart=on-failure
RestartSec=2
NoNewPrivileges=true
PrivateTmp=true
ProtectHome=true
ProtectSystem=strict
ReadWritePaths=$STATE_DIR
ProtectKernelTunables=true
ProtectKernelModules=true
ProtectControlGroups=true
RestrictSUIDSGID=true

[Install]
WantedBy=multi-user.target
EOF
chmod 0644 "$UNIT"

systemctl daemon-reload
systemctl enable "$SERVICE" >/dev/null
systemctl restart "$SERVICE"

for _ in $(seq 1 20); do
  systemctl is-active --quiet "$SERVICE" && break
  sleep 0.25
done

if ! systemctl is-active --quiet "$SERVICE"; then
  echo "NovaRelay failed to start. Recent service log:" >&2
  journalctl -u "$SERVICE" -n 30 --no-pager >&2 || true
  exit 1
fi

PASSWORD_FILE="$STATE_DIR/relay_password.txt"
for _ in $(seq 1 20); do
  [[ -s "$PASSWORD_FILE" ]] && break
  sleep 0.25
done

cat <<EOF

NovaRelay installation complete.

Service:        $SERVICE
Listen address: 0.0.0.0:$PORT
Binary:         $INSTALL_DIR/novarelay
State:          $STATE_DIR

Check service:
  sudo systemctl status $SERVICE --no-pager

View logs:
  sudo journalctl -u $SERVICE -f
EOF

if [[ -s "$PASSWORD_FILE" ]]; then
  echo
  echo "Show the relay password:"
  echo "  sudo cat $PASSWORD_FILE"
else
  echo
  echo "WARNING: relay_password.txt was not created yet. Check the service log."
fi

cat <<EOF

NETWORK SETUP STILL REQUIRED
----------------------------
VPS/cloud:
  Allow inbound TCP $PORT in the provider firewall/security group and host firewall.

Home server:
  1. Reserve a stable LAN IP for this machine in the router.
  2. Port-forward external TCP $PORT to this machine's LAN IP:$PORT.
  3. Allow TCP $PORT in the Linux firewall if one is active.
  4. Use a reachable public IPv4 address. Static public IPv4 is recommended.

If your ISP uses CGNAT, normal IPv4 port forwarding usually will not work.
Ask the ISP for a public/static IPv4 address or use a VPS.

NovaChat relay address example:
  chat.example.com:$PORT

Do not use http:// or https://.

Full guide:
  https://github.com/$REPO/blob/main/RELAY_INSTALL.md
EOF
