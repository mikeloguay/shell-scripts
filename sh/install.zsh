#!/usr/bin/env zsh
# =============================================================================
# install.zsh – One-time installer for the team shell scripts
#
# Usage:
#   zsh sh/install.zsh
#
# What it does:
#   1. Resolves the absolute path of this repo.
#   2. Appends a single `source` line to ~/.zshrc that loads the main loader.
#   3. After that, `git pull` is all you ever need for updates.
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Resolve the repo root (works even if script is called from any directory)
# ---------------------------------------------------------------------------
SCRIPT_DIR="${0:A:h}"          # absolute path of the sh/ directory
REPO_ROOT="${SCRIPT_DIR:h}"    # one level up = repo root
LOADER="${SCRIPT_DIR}/loader.zsh"
ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"
MARKER="# >>> team-shell-scripts >>>"

# ---------------------------------------------------------------------------
# Guard: don't add a duplicate entry
# ---------------------------------------------------------------------------
if grep -qF "$MARKER" "$ZSHRC" 2>/dev/null; then
  echo "✅  team-shell-scripts is already installed in ${ZSHRC}."
  echo "    Run 'git pull' inside ${REPO_ROOT} to get the latest scripts."
  exit 0
fi

# ---------------------------------------------------------------------------
# Append source block to ~/.zshrc
# ---------------------------------------------------------------------------
cat >> "$ZSHRC" <<EOF

${MARKER}
# Team shell scripts – loaded from ${REPO_ROOT}
# To update: cd ${REPO_ROOT} && git pull
[ -f "${LOADER}" ] && source "${LOADER}"
# <<< team-shell-scripts <<<
EOF

echo ""
echo "✅  Installed! The following line was added to ${ZSHRC}:"
echo ""
echo "    source \"${LOADER}\""
echo ""
echo "👉  Reload your shell now:  source ~/.zshrc"
echo "    Or just open a new terminal tab."
echo ""
echo "🔄  To update scripts in the future:"
echo "    cd ${REPO_ROOT} && git pull"
echo ""
