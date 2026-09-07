# NovaChat Installation Guide

Official client installation instructions for **NovaChat** by **Ruen IT Services**.

The Linux and Windows bootstrap installers do **not** hard-code a distribution version. They read `bootstrap-release.txt`, download the package referenced there from GitHub Releases, verify its SHA-256 checksum, and then run the packaged installer. After a new `v...-dist.N` release is published, repository automation advances `bootstrap-release.txt` to that release.

> Looking to host your own relay? See **[RELAY_INSTALL.md](RELAY_INSTALL.md)**.

## Android

Download the newest NovaChat APK from the **[Releases](https://github.com/ufukmehmedov/NovaChat-Releases/releases)** page and install the `NovaChat_Android_*.apk` asset.

On Android, use `/en`, `/bg`, or `/tr` to select English, Bulgarian, or Turkish. Command names remain unchanged.

To uninstall NovaChat, use Android's normal app removal flow:

**Settings → Apps → NovaChat → Uninstall**

## Windows (x64)

### Requirements

- Windows x64
- Windows PowerShell
- Internet access to GitHub Releases

### Install or update

Open **PowerShell** and run:

```powershell
irm https://raw.githubusercontent.com/ufukmehmedov/NovaChat-Releases/main/install.ps1 | iex
```

When installation finishes, open a new PowerShell window and start NovaChat with:

```powershell
novachat
```

Running the same installation command again updates NovaChat to the distribution referenced by `bootstrap-release.txt`. If NovaChat is running, the installer stops the installed process before replacing the executable.

### Uninstall

Close NovaChat, then run this PowerShell block. It removes the installed program and its PATH entry but **preserves** the NovaChat profile, keys, and history in `~\.novachat-e2ee`.

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

To erase the preserved local NovaChat profile, keys, and history as well, remove `~\.novachat-e2ee` separately only if you intentionally want to delete that data.

## Linux (x86_64 / amd64)

### Requirements

- Linux x86_64 / amd64
- `curl`
- `unzip`
- `sha256sum` or `shasum`
- Internet access to GitHub Releases

### Install or update

Open a terminal and run:

```bash
curl -fsSL https://raw.githubusercontent.com/ufukmehmedov/NovaChat-Releases/main/install.sh | bash
```

When installation finishes, start NovaChat with:

```bash
novachat
```

Running the same installation command again updates NovaChat to the distribution referenced by `bootstrap-release.txt`.

### Uninstall

Close NovaChat, then run:

```bash
pkill -x novachat 2>/dev/null || true
rm -rf "$HOME/.local/lib/novachat"
rm -f "$HOME/.local/bin/novachat" "$HOME/.local/share/applications/novachat.desktop"
```

This preserves the NovaChat profile, keys, and history in `$HOME/.novachat-e2ee`.

To permanently erase that local data too, run this only if you intentionally want to delete it:

```bash
rm -rf "$HOME/.novachat-e2ee"
```

## Package verification

The bootstrap installers read the active release metadata from `bootstrap-release.txt`, download the matching package from GitHub Releases, calculate its SHA-256 checksum, and stop the installation if the checksum does not match the published value.

Each public distribution also includes:

- `SHA256SUMS.txt`
- `release-manifest.json`

These files can be used for independent verification of release artifacts.

## Releases

Official public binaries are published only in the **NovaChat-Releases** repository under GitHub Releases.

NovaChat is currently distributed as alpha/pre-release software. Version numbers and installation behavior may change while development continues.

## License and copyright

NovaChat and NovaRelay are proprietary software by **Ruen IT Services**. Public availability of release binaries does not grant an open-source license.

See `COPYRIGHT.md` in this repository for the current copyright notice.
