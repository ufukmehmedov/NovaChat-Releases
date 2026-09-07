# NovaChat Releases

Official binary distribution repository for **NovaChat** and **NovaRelay** by **Ruen IT Services**.

> **Alpha software:** NovaChat is under active development. Back up important data and report problems through GitHub Issues.

## Download NovaChat

Use the **[Releases](https://github.com/ufukmehmedov/NovaChat-Releases/releases)** page for the newest public distribution and its checksums.

The Linux, Windows, and NovaRelay bootstrap installers do **not** hard-code a `dist` tag. They read `bootstrap-release.txt`, verify the referenced package with SHA-256, and install that published distribution. Repository automation advances the pointer when a new `v...-dist.N` release is published.

## Install NovaChat

For the complete client installation, update, and uninstall guide, see **[INSTALL.md](INSTALL.md)**.

### Android

Download the newest `NovaChat_Android_*.apk` from the **[Releases](https://github.com/ufukmehmedov/NovaChat-Releases/releases)** page and install it on the Android device.

To uninstall:

**Settings → Apps → NovaChat → Uninstall**

### Linux (x86_64 / amd64)

Install or update to the currently published distribution:

```bash
curl -fsSL https://raw.githubusercontent.com/ufukmehmedov/NovaChat-Releases/main/install.sh | bash
```

Start NovaChat with `novachat`.

Uninstall the program while preserving profile/keys/history:

```bash
pkill -x novachat 2>/dev/null || true
rm -rf "$HOME/.local/lib/novachat"
rm -f "$HOME/.local/bin/novachat" "$HOME/.local/share/applications/novachat.desktop"
```

### Windows (x64)

Open PowerShell and install or update to the currently published distribution:

```powershell
irm https://raw.githubusercontent.com/ufukmehmedov/NovaChat-Releases/main/install.ps1 | iex
```

Open a new PowerShell window and start NovaChat with `novachat`.

Uninstall the program while preserving profile/keys/history:

```powershell
Get-Process novachat -ErrorAction SilentlyContinue | Stop-Process -Force
$root = Join-Path $env:LOCALAPPDATA "NovaChat"
$bin = Join-Path $root "bin"
Remove-Item -LiteralPath $root -Recurse -Force -ErrorAction SilentlyContinue
$p = [Environment]::GetEnvironmentVariable("Path", "User")
if ($p) {
    $clean = (($p -split ';') | Where-Object {
        $_ -and $_.Trim().TrimEnd('\') -ine $bin.TrimEnd('\')
    }) -join ';'
    [Environment]::SetEnvironmentVariable("Path", $clean, "User")
}
```

The preserved local data directory is `~/.novachat-e2ee` on Linux and `~\.novachat-e2ee` on Windows. Delete it separately only if you intentionally want to erase the local profile, keys, and history.

## Self-host NovaRelay

For the complete network, firewall, static-IP/DDNS, port-forwarding, update, and uninstall guide, see **[RELAY_INSTALL.md](RELAY_INSTALL.md)**.

On a supported Debian/Ubuntu x86_64 server, install or update NovaRelay with:

```bash
curl -fsSL https://raw.githubusercontent.com/ufukmehmedov/NovaChat-Releases/main/install-relay.sh | sudo bash
```

The default relay port is TCP `7777`. The installer creates an isolated systemd service and preserves the relay password when the same port is upgraded.

Uninstall the relay service and binary for port `7777` while preserving its password/state:

```bash
PORT=7777
sudo systemctl disable --now "novarelay-$PORT.service" 2>/dev/null || true
sudo rm -f "/etc/systemd/system/novarelay-$PORT.service"
sudo rm -rf "/opt/novarelay/$PORT"
sudo systemctl daemon-reload
```

NovaRelay is a raw TCP service. NovaChat clients use an address such as `chat.example.com:7777`, without `http://` or `https://`.

## Help and feedback

- Contact: **[events@barkurt.com](mailto:events@barkurt.com)**
- Read **[SUPPORT.md](SUPPORT.md)** before asking for help.
- Report reproducible bugs with the **[bug report form](https://github.com/ufukmehmedov/NovaChat-Releases/issues/new?template=bug_report.yml)**.
- Suggest improvements with the **[feature request form](https://github.com/ufukmehmedov/NovaChat-Releases/issues/new?template=feature_request.yml)**.
- For security problems, follow **[SECURITY.md](SECURITY.md)** and do not publish sensitive details in a public issue.

## Release files

This repository contains official release artifacts and installation resources only:

- Android APK
- Linux package
- Windows package
- NovaRelay Linux package
- `INSTALL.md`
- `RELAY_INSTALL.md`
- `install.sh`
- `install.ps1`
- `install-relay.sh`
- `release-manifest.json`
- `SHA256SUMS.txt`

The NovaChat and NovaRelay source code is **not published in this repository**.

GitHub automatically displays “Source code” archives for every release tag. Those archives contain only this public distribution repository's installer scripts and documentation; they do **not** contain the private NovaChat or NovaRelay application source code.

Public availability of these binaries does not grant permission to copy, modify,
redistribute, reverse engineer, rebrand, or commercially exploit NovaChat or
NovaRelay except where applicable law provides otherwise.

Copyright © Ruen IT Services. All rights reserved.
