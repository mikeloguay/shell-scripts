# =============================================================================
# git-utils.plugin.zsh – Git productivity aliases and functions
# =============================================================================

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------

# Short status
alias gs='git status -sb'

# Pretty one-line log with graph
alias glog='git log --oneline --graph --decorate --all'

# Quick push to current branch
alias gpush='git push origin "$(git_current_branch)"'

# Quick pull with rebase (keeps history clean)
alias gpull='git pull --rebase origin "$(git_current_branch)"'

# ---------------------------------------------------------------------------
# Helper: current branch name
# ---------------------------------------------------------------------------
function git_current_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# ---------------------------------------------------------------------------
# gclean – Delete all local branches already merged into main/master
# ---------------------------------------------------------------------------
function gclean() {
  local base="${1:-main}"

  echo "🧹 Deleting branches merged into '${base}'..."
  git branch --merged "$base" \
    | grep -vE "^\*|^\s*(${base}|master|main|develop)$" \
    | xargs -r git branch -d
  echo "✅ Done."
}

# ---------------------------------------------------------------------------
# gnew – Create a new branch from the latest main/master and push it
# Usage: gnew <branch-name> [base-branch]
# ---------------------------------------------------------------------------
function gnew() {
  local branch="$1"
  local base="${2:-main}"

  if [[ -z "$branch" ]]; then
    echo "Usage: gnew <branch-name> [base-branch]"
    return 1
  fi

  echo "🌿 Creating branch '${branch}' from '${base}'..."
  git fetch origin "$base"
  git checkout -b "$branch" "origin/${base}"
  git push -u origin "$branch"
  echo "✅ Branch '${branch}' created and pushed."
}

# ---------------------------------------------------------------------------
# gundo – Undo the last commit, keeping changes staged
# ---------------------------------------------------------------------------
function gundo() {
  git reset --soft HEAD~1
  echo "↩️  Last commit undone. Changes are still staged."
}
