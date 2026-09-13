#!/usr/bin/env zsh
# =============================================================================
# loader.zsh – Auto-discovers and sources every plugin in the sh/ directory.
#
# Convention: each group folder contains a file named <group>.plugin.zsh
#   sh/
#   ├── git-utils/
#   │   └── git-utils.plugin.zsh
#   ├── rabbitmq-utils/
#   │   └── rabbitmq-utils.plugin.zsh
#   └── loader.zsh   ← (this file)
#
# Adding a new group: just drop a new folder with a .plugin.zsh file.
# No changes needed here or in ~/.zshrc.
# =============================================================================

_TEAM_SCRIPTS_DIR="${0:A:h}"   # absolute path of the sh/ directory

for _plugin_file in "${_TEAM_SCRIPTS_DIR}"/**/*.plugin.zsh; do
  [[ -f "$_plugin_file" ]] && source "$_plugin_file"
done

unset _TEAM_SCRIPTS_DIR _plugin_file
