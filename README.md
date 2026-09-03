# NovaChat Releases

Official binary distribution repository for **NovaChat** and **NovaRelay** by **Ruen IT Services**.

> **Alpha software:** NovaChat is under active development. Back up important data and report problems through GitHub Issues.

## Download NovaChat

The current public pre-release is **[v0.7.21-dist.7](https://github.com/ufukmehmedov/NovaChat-Releases/releases/tag/v0.7.21-dist.7)**:

| Platform | Version | Download / install |
| --- | --- | --- |
| Android | `0.7.21-android-alpha44` | **[Download APK](https://github.com/ufukmehmedov/NovaChat-Releases/releases/download/v0.7.21-dist.7/NovaChat_Android_0.7.21-android-alpha44.apk)** |
| Linux | `0.7.21-alpha23` | Use the installation command below |
| Windows | `0.7.21-alpha24` | Use the installation command below |
| NovaRelay | `0.7.21-alpha7` | See the self-hosting section |

Android alpha44 supports `/en`, `/bg`, and `/tr` for English, Bulgarian, and Turkish interface text.

For checksums and every downloadable file, open the **[release page](https://github.com/ufukmehmedov/NovaChat-Releases/releases/tag/v0.7.21-dist.7)**.

## Install NovaChat

For the complete client installation and update guide, see **[INSTALL.md](INSTALL.md)**.

### Android

1. Download the official APK using the link above.
2. Open the downloaded file on the Android device.
3. If Android asks, temporarily allow installation from the app used to open the APK.
4. Confirm the installation.

Only install NovaChat files published by **Ruen IT Services** in this repository.

### Linux (x86_64 / amd64)

```bash
curl -fsSL https://raw.githubusercontent.com/ufukmehmedov/NovaChat-Releases/main/install.sh | bash
```

Start NovaChat with `novachat`.

### Windows (x64)

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/ufukmehmedov/NovaChat-Releases/main/install.ps1 | iex
```

Open a new PowerShell window and start NovaChat with `novachat`.

The desktop bootstrap installers download the current public NovaChat package, verify its SHA-256 checksum, and run the platform installer. Administrator/root access is not required.

## Self-host NovaRelay

For the complete network, firewall, static-IP/DDNS and port-forwarding guide, see **[RELAY_INSTALL.md](RELAY_INSTALL.md)**.

On a supported Debian/Ubuntu x86_64 server, the one-command relay installer is:

```bash
curl -fsSL https://raw.githubusercontent.com/ufukmehmedov/NovaChat-Releases/main/install-relay.sh | sudo bash
```

The default relay port is TCP `7777`. The installer creates an isolated systemd service and preserves the relay password when the same port is upgraded.

NovaRelay is a raw TCP service. NovaChat clients use an address such as `chat.example.com:7777`, without `http://` or `https://`.

## Help and feedback

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
