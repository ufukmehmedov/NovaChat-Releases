$ErrorActionPreference = "Stop"

$Repo = "ufukmehmedov/NovaChat-Releases"
$RawBase = "https://raw.githubusercontent.com/$Repo/main"
$ReleaseBase = "https://github.com/$Repo/releases/download"
$MetaUrl = "$RawBase/bootstrap-release.txt"
$Headers = @{ "User-Agent" = "NovaChat-Bootstrap" }

function Get-MetaValue {
    param([string]$Text, [string]$Key)
    foreach ($line in ($Text -split "`r?`n")) {
        if ($line.StartsWith($Key + "=")) {
            return $line.Substring($Key.Length + 1).Trim()
        }
    }
    return ""
}

function Stop-InstalledNovaChat {
    if ([string]::IsNullOrWhiteSpace($env:LOCALAPPDATA)) { return }

    $InstalledExe = Join-Path $env:LOCALAPPDATA "NovaChat\bin\novachat.exe"
    if (-not (Test-Path -LiteralPath $InstalledExe)) { return }

    $TargetPath = [IO.Path]::GetFullPath($InstalledExe)
    $Processes = @(Get-Process -Name "novachat" -ErrorAction SilentlyContinue)
    $StoppedAny = $false

    foreach ($Process in $Processes) {
        $ProcessPath = $null
        try { $ProcessPath = $Process.Path } catch { }

        $MatchesInstalledExe = $false
        if ([string]::IsNullOrWhiteSpace($ProcessPath)) {
            # If Windows does not expose the path, prefer a clean one-command update
            # over leaving the known NovaChat executable locked.
            $MatchesInstalledExe = $true
        }
        else {
            try {
                $MatchesInstalledExe = [string]::Equals(
                    [IO.Path]::GetFullPath($ProcessPath),
                    $TargetPath,
                    [StringComparison]::OrdinalIgnoreCase
                )
            }
            catch { }
        }

        if ($MatchesInstalledExe) {
            if (-not $StoppedAny) {
                Write-Host "Stopping running NovaChat before update..." -ForegroundColor Yellow
                $StoppedAny = $true
            }
            Stop-Process -Id $Process.Id -Force -ErrorAction Stop
            try { $null = $Process.WaitForExit(5000) } catch { }
        }
    }

    if ($StoppedAny) {
        Start-Sleep -Milliseconds 250
    }
}

$TempDir = Join-Path ([IO.Path]::GetTempPath()) ("novachat-bootstrap-" + [Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $TempDir | Out-Null

try {
    $Meta = (Invoke-WebRequest -UseBasicParsing -Headers $Headers -Uri $MetaUrl).Content
    $Tag = Get-MetaValue $Meta "TAG"
    $Asset = Get-MetaValue $Meta "WINDOWS_ASSET"
    $ExpectedSha = (Get-MetaValue $Meta "WINDOWS_SHA256").ToLowerInvariant()

    if ($Tag -notmatch '^v[0-9A-Za-z._-]+$') { throw "Invalid release tag." }
    if ($Asset -notmatch '^NovaChat_Windows_[0-9A-Za-z._-]+\.zip$') { throw "Invalid Windows asset name." }
    if ($ExpectedSha -notmatch '^[0-9a-f]{64}$') { throw "Invalid Windows SHA-256." }

    $ZipPath = Join-Path $TempDir $Asset
    $Url = "$ReleaseBase/$Tag/$Asset"
    Write-Host "Downloading NovaChat $Tag..." -ForegroundColor Cyan
    Invoke-WebRequest -UseBasicParsing -Headers $Headers -Uri $Url -OutFile $ZipPath

    $ActualSha = (Get-FileHash -Algorithm SHA256 -LiteralPath $ZipPath).Hash.ToLowerInvariant()
    if ($ActualSha -ne $ExpectedSha) {
        throw "SHA-256 verification failed. Installation stopped."
    }
    Write-Host "SHA-256 verified." -ForegroundColor Green

    $PackageDir = Join-Path $TempDir "package"
    Expand-Archive -LiteralPath $ZipPath -DestinationPath $PackageDir -Force
    $Installer = Join-Path $PackageDir "INSTALL_NOVACHAT_WINDOWS.ps1"
    if (-not (Test-Path -LiteralPath $Installer)) {
        throw "INSTALL_NOVACHAT_WINDOWS.ps1 not found in package."
    }

    Stop-InstalledNovaChat

    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $Installer
    if ($LASTEXITCODE -ne 0) {
        throw "NovaChat package installer failed with exit code $LASTEXITCODE."
    }

    Write-Host ""
    Write-Host "NovaChat installation complete. Open a new PowerShell and run: novachat" -ForegroundColor Green
}
finally {
    Remove-Item -LiteralPath $TempDir -Recurse -Force -ErrorAction SilentlyContinue
}
