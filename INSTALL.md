# NovaChat Installation Guide

Official installation instructions for **NovaChat** by **Ruen IT Services**.

NovaChat desktop installers download the current public release from this repository, verify the package with **SHA-256**, and install it for the current user. Administrator/root access is not required.

## Windows (x64)

### Requirements

- Windows x64
- Windows PowerShell
- Internet access to GitHub Releases

### Install or update

Open **PowerShell** and run this single command:

```powershell
irm https://raw.githubusercontent.com/ufukmehmedov/NovaChat-Releases/main/install.ps1 | iex
```

When installation finishes, open a new PowerShell window and start NovaChat with:

```powershell
novachat
```

To update NovaChat later, run the same installation command again. If NovaChat is running, the installer stops the installed NovaChat process before replacing the executable.

## Linux (x86_64 / amd64)

### Requirements

- Linux x86_64 / amd64
- `curl`
- `unzip`
- `sha256sum` or `shasum`
- Internet access to GitHub Releases

### Install or update

Open a terminal and run this single command:

```bash
curl -fsSL https://raw.githubusercontent.com/ufukmehmedov/NovaChat-Releases/main/install.sh | bash
```

When installation finishes, start NovaChat with:

```bash
novachat
```

To update NovaChat later, run the same installation command again.

## Package verification

The bootstrap installers read the current release metadata from `bootstrap-release.txt`, download the matching package from GitHub Releases, calculate its SHA-256 checksum, and stop the installation if the checksum does not match the published value.

Each public release also includes:

- `SHA256SUMS.txt`
- `release-manifest.json`

These files can be used for independent verification of release artifacts.

## Releases

Official public binaries are published only in the **NovaChat-Releases** repository under GitHub Releases.

NovaChat is currently distributed as alpha/pre-release software. Version numbers and installation behavior may change while development continues.

## License and copyright

NovaChat and NovaRelay are proprietary software by **Ruen IT Services**. Public availability of release binaries does not grant an open-source license.

See `COPYRIGHT.md` in this repository for the current copyright notice.
