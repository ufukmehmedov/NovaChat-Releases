# NovaChat Releases

Official binary distribution repository for **NovaChat** by **Ruen IT Services**.

## One-command install

### Linux (x86_64 / amd64)

```bash
curl -fsSL https://raw.githubusercontent.com/ufukmehmedov/NovaChat-Releases/main/install.sh | bash
```

Then start NovaChat with:

```bash
novachat
```

### Windows

Open **PowerShell** and run:

```powershell
irm https://raw.githubusercontent.com/ufukmehmedov/NovaChat-Releases/main/install.ps1 | iex
```

Then open a new PowerShell window and run:

```powershell
novachat
```

The bootstrap installers download the current public NovaChat desktop package, verify its SHA-256 checksum, and run the platform installer. Administrator/root access is not required.

## Release files

This repository contains release artifacts only:

- Android APK
- Linux package
- Windows package
- NovaRelay Linux package
- `release-manifest.json`
- `SHA256SUMS.txt`

The NovaChat source code is **not published in this repository**.

Public availability of these binaries does not grant permission to copy, modify,
redistribute, reverse engineer, rebrand, or commercially exploit NovaChat except
where applicable law provides otherwise.

Copyright © Ruen IT Services. All rights reserved.
