# 🐚 zsh Scripts

Shell scripts for **zsh** users (macOS / Linux).

---

## 🚀 Installation (one-time)

```zsh
git clone <repo-url> ~/team-scripts
cd ~/team-scripts
zsh sh/install.zsh
source ~/.zshrc   # or open a new terminal
```

The installer adds a single `source` line to your `~/.zshrc` pointing to
[`loader.zsh`](./loader.zsh). All plugins are picked up automatically.

## 🔄 Updating

```zsh
cd ~/team-scripts && git pull   # that's all
```

## 🗑️ Uninstalling

```zsh
zsh sh/uninstall.zsh
```

---

## 📦 Plugins

### `git-utils`

> File: [`git-utils/git-utils.plugin.zsh`](./git-utils/git-utils.plugin.zsh)

| Command / Alias | Description |
|---|---|
| `gs` | `git status -sb` |
| `glog` | Pretty graph log |
| `gpush` | Push current branch to origin |
| `gpull` | Pull with rebase |
| `gclean [base]` | Delete local branches merged into `base` (default: `main`) |
| `gnew <branch> [base]` | Create branch from latest `base` and push |
| `gundo` | Undo last commit, keep changes staged |

### `rabbitmq-utils`

> File: [`rabbitmq-utils/rabbitmq-utils.plugin.zsh`](./rabbitmq-utils/rabbitmq-utils.plugin.zsh)

Requires: `curl`, `jq`

**Optional env var overrides** (add to your `~/.zshrc`):
```zsh
export RABBITMQ_HOST=http://my-rabbit:15672
export RABBITMQ_USER=admin
export RABBITMQ_PASS=secret
```

| Command | Description |
|---|---|
| `rmq-status` | Cluster overview |
| `rmq-queues` | List queues with message/consumer counts |
| `rmq-purge <queue>` | Purge all messages from a queue |
| `rmq-publish <queue> <msg>` | Publish a test message |

---

## ➕ Adding a New Plugin Group

1. Create `sh/<group-name>/<group-name>.plugin.zsh`
2. Write your aliases and functions inside it
3. Commit and push — the loader discovers it automatically

```
sh/
└── my-new-group/
    └── my-new-group.plugin.zsh   ← add this
```
