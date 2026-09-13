# =============================================================================
# install.ps1 – One-time installer for the team PowerShell scripts
#
# Usage (from repo root):
#   pwsh ps/install.ps1
#   # or on Windows PowerShell:
#   powershell -ExecutionPolicy Bypass -File ps\install.ps1
#
# What it does:
#   1. Resolves the absolute path of this repo.
#   2. Appends a single dot-source line to $PROFILE that loads the main loader.
#   3. After that, `git pull` is all you ever need for updates.
#
# Requires: PowerShell 5.1+ or PowerShell 7+ (pwsh)
# =============================================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Resolve paths
# ---------------------------------------------------------------------------
$ScriptDir = $PSScriptRoot                            # absolute path of ps/
$LoaderPath = Join-Path $ScriptDir 'loader.ps1'
$ProfilePath = $PROFILE.CurrentUserAllHosts           # works on Win/macOS/Linux
$Marker = '# >>> team-shell-scripts >>>'

# ---------------------------------------------------------------------------
# Guard: don't add a duplicate entry
# ---------------------------------------------------------------------------
if (Test-Path $ProfilePath) {
    $existing = Get-Content $ProfilePath -Raw -ErrorAction SilentlyContinue
    if ($existing -and $existing.Contains($Marker)) {
        Write-Host "✅  team-shell-scripts is already installed in:`n    $ProfilePath" -ForegroundColor Green
        Write-Host "    Run 'git pull' in the repo to get the latest scripts." -ForegroundColor Cyan
        exit 0
    }
}

# ---------------------------------------------------------------------------
# Ensure the profile file and its parent directory exist
# ---------------------------------------------------------------------------
$ProfileDir = Split-Path $ProfilePath -Parent
if (-not (Test-Path $ProfileDir)) {
    New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
}
if (-not (Test-Path $ProfilePath)) {
    New-Item -ItemType File -Path $ProfilePath -Force | Out-Null
}

# ---------------------------------------------------------------------------
# Append the source block to $PROFILE
# ---------------------------------------------------------------------------
$block = @"


$Marker
# Team shell scripts - loaded from $ScriptDir
# To update: cd <repo-root> && git pull
if (Test-Path "$LoaderPath") { . "$LoaderPath" }
# <<< team-shell-scripts <<<
"@

Add-Content -Path $ProfilePath -Value $block

Write-Host ""
Write-Host "✅  Installed! The following block was added to:" -ForegroundColor Green
Write-Host "    $ProfilePath" -ForegroundColor White
Write-Host ""
Write-Host "    . `"$LoaderPath`"" -ForegroundColor DarkGray
Write-Host ""
Write-Host "👉  Reload your shell now:" -ForegroundColor Yellow
Write-Host "    . `$PROFILE" -ForegroundColor White
Write-Host "    Or just open a new PowerShell window." -ForegroundColor DarkGray
Write-Host ""
Write-Host "🔄  To update scripts in the future:" -ForegroundColor Yellow
Write-Host "    cd <repo-root> && git pull" -ForegroundColor White
Write-Host ""
