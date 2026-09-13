# =============================================================================
# uninstall.ps1 – Removes the team-shell-scripts block from $PROFILE
# Usage: pwsh ps/uninstall.ps1
# =============================================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ProfilePath = $PROFILE.CurrentUserAllHosts
$MarkerStart = '# >>> team-shell-scripts >>>'
$MarkerEnd   = '# <<< team-shell-scripts <<<'

if (-not (Test-Path $ProfilePath)) {
    Write-Host "ℹ️  No profile found at $ProfilePath. Nothing to do." -ForegroundColor Cyan
    exit 0
}

$content = Get-Content $ProfilePath -Raw
if (-not $content.Contains($MarkerStart)) {
    Write-Host "ℹ️  team-shell-scripts is not installed in:`n    $ProfilePath" -ForegroundColor Cyan
    exit 0
}

# ---------------------------------------------------------------------------
# Backup the profile before modifying
# ---------------------------------------------------------------------------
$backup = "$ProfilePath.bak"
Copy-Item -Path $ProfilePath -Destination $backup -Force
Write-Host "💾 Backup saved to $backup" -ForegroundColor DarkGray

# ---------------------------------------------------------------------------
# Remove the block between markers (inclusive), including leading blank line
# ---------------------------------------------------------------------------
$lines   = Get-Content $ProfilePath
$output  = [System.Collections.Generic.List[string]]::new()
$inside  = $false
$skipNext = $false

foreach ($line in $lines) {
    if ($line.TrimEnd() -eq $MarkerStart) {
        # Also remove the blank line immediately before the marker
        if ($output.Count -gt 0 -and $output[$output.Count - 1].Trim() -eq '') {
            $output.RemoveAt($output.Count - 1)
        }
        $inside = $true
        continue
    }
    if ($line.TrimEnd() -eq $MarkerEnd) {
        $inside = $false
        continue
    }
    if (-not $inside) {
        $output.Add($line)
    }
}

Set-Content -Path $ProfilePath -Value $output

Write-Host ""
Write-Host "✅  team-shell-scripts has been removed from:" -ForegroundColor Green
Write-Host "    $ProfilePath" -ForegroundColor White
Write-Host ""
Write-Host "    Reload your shell:  . `$PROFILE" -ForegroundColor DarkGray
Write-Host ""
