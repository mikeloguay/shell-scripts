#!/usr/bin/env zsh
# =============================================================================
# uninstall.zsh – Removes the team-shell-scripts block from ~/.zshrc
# Usage: zsh sh/uninstall.zsh
# =============================================================================

set -euo pipefail

ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"
MARKER_START="# >>> team-shell-scripts >>>"
MARKER_END="# <<< team-shell-scripts <<<"

if ! grep -qF "$MARKER_START" "$ZSHRC" 2>/dev/null; then
  echo "ℹ️  team-shell-scripts is not installed in ${ZSHRC}. Nothing to do."
  exit 0
fi

# Create a backup before modifying
cp "$ZSHRC" "${ZSHRC}.bak"
echo "💾 Backup saved to ${ZSHRC}.bak"

# Remove the block between the markers (inclusive)
# Use a temp file for portability
local tmpfile
tmpfile=$(mktemp)
awk "
  /^${MARKER_START}/{found=1; next}
  /^${MARKER_END}/{found=0; next}
  !found
" "$ZSHRC" > "$tmpfile"

mv "$tmpfile" "$ZSHRC"

echo "✅  team-shell-scripts has been removed from ${ZSHRC}."
echo "    Reload your shell:  source ~/.zshrc"
