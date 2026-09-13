# =============================================================================
# loader.ps1 – Auto-discovers and dot-sources every plugin in the ps/ directory.
#
# Convention: each group folder contains a file named <group>.plugin.ps1
#   ps/
#   ├── git-utils/
#   │   └── git-utils.plugin.ps1
#   ├── rabbitmq-utils/
#   │   └── rabbitmq-utils.plugin.ps1
#   └── loader.ps1   <- (this file)
#
# Adding a new group: just drop a new folder with a .plugin.ps1 file.
# No changes needed here or in $PROFILE.
# =============================================================================

$_TeamScriptsDir = $PSScriptRoot

Get-ChildItem -Path $_TeamScriptsDir -Recurse -Filter '*.plugin.ps1' | ForEach-Object {
    . $_.FullName
}

Remove-Variable -Name '_TeamScriptsDir' -Scope Local -ErrorAction SilentlyContinue
