# Git test alias
function Invoke-GitTest { Write-Host "git-utils loaded successfully" }
Set-Alias -Name git-test -Value Invoke-GitTest -Scope Global -Option AllScope -Force

# Git pretty log
function Invoke-GitLog { git log --oneline --graph --decorate --all @args }
Set-Alias -Name glog -Value Invoke-GitLog -Scope Global -Option AllScope -Force
