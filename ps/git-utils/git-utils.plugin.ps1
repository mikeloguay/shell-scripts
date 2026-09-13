# =============================================================================
# git-utils.plugin.ps1 – Git productivity aliases and functions for PowerShell
# =============================================================================

# ---------------------------------------------------------------------------
# Helper: get the current branch name
# ---------------------------------------------------------------------------
function Get-GitCurrentBranch {
    git rev-parse --abbrev-ref HEAD 2>$null
}

# ---------------------------------------------------------------------------
# Aliases (PowerShell-style: Set-Alias for simple commands)
# ---------------------------------------------------------------------------

# Short status
function Invoke-GitStatus { git status -sb @args }
Set-Alias -Name gs -Value Invoke-GitStatus -Scope Global -Option AllScope -Force

# Pretty graph log
function Invoke-GitLog { git log --oneline --graph --decorate --all @args }
Set-Alias -Name glog -Value Invoke-GitLog -Scope Global -Option AllScope -Force

# ---------------------------------------------------------------------------
# gpush – Push the current branch to origin
# ---------------------------------------------------------------------------
function gpush {
    $branch = Get-GitCurrentBranch
    if (-not $branch) {
        Write-Error "Not inside a git repository."
        return
    }
    git push origin $branch @args
}

# ---------------------------------------------------------------------------
# gpull – Pull with rebase (keeps history clean)
# ---------------------------------------------------------------------------
function gpull {
    $branch = Get-GitCurrentBranch
    if (-not $branch) {
        Write-Error "Not inside a git repository."
        return
    }
    git pull --rebase origin $branch @args
}

# ---------------------------------------------------------------------------
# Invoke-GitClean (gclean) – Delete local branches merged into main/master
# Usage: gclean [-Base main]
# ---------------------------------------------------------------------------
function Invoke-GitClean {
    param(
        [string]$Base = 'main'
    )

    Write-Host "🧹 Deleting branches merged into '$Base'..." -ForegroundColor Yellow

    $merged = git branch --merged $Base |
        Where-Object { $_ -notmatch '^\*' -and $_.Trim() -notmatch "^($Base|master|main|develop)$" } |
        ForEach-Object { $_.Trim() }

    if (-not $merged) {
        Write-Host "   Nothing to clean." -ForegroundColor DarkGray
        return
    }

    $merged | ForEach-Object {
        git branch -d $_
    }
    Write-Host "✅ Done." -ForegroundColor Green
}
Set-Alias -Name gclean -Value Invoke-GitClean -Scope Global -Option AllScope -Force

# ---------------------------------------------------------------------------
# Invoke-GitNew (gnew) – Create a new branch from the latest base and push
# Usage: gnew <branch-name> [-Base main]
# ---------------------------------------------------------------------------
function Invoke-GitNew {
    param(
        [Parameter(Mandatory)]
        [string]$BranchName,

        [string]$Base = 'main'
    )

    Write-Host "🌿 Creating branch '$BranchName' from '$Base'..." -ForegroundColor Yellow
    git fetch origin $Base
    git checkout -b $BranchName "origin/$Base"
    git push -u origin $BranchName
    Write-Host "✅ Branch '$BranchName' created and pushed." -ForegroundColor Green
}
Set-Alias -Name gnew -Value Invoke-GitNew -Scope Global -Option AllScope -Force

# ---------------------------------------------------------------------------
# Invoke-GitUndo (gundo) – Undo the last commit, keeping changes staged
# ---------------------------------------------------------------------------
function Invoke-GitUndo {
    git reset --soft HEAD~1
    Write-Host "↩️  Last commit undone. Changes are still staged." -ForegroundColor Cyan
}
Set-Alias -Name gundo -Value Invoke-GitUndo -Scope Global -Option AllScope -Force
