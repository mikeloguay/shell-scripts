# 🛠️ Team Shell Scripts

A centralized repository for shared shell scripts used across the development team.

## How it works

- Scripts are **grouped by domain** (e.g. `git-utils`, `rabbitmq-utils`).
- A single `source` line is added to your `~/.zshrc` — pointing to this repo.
- **Updates are just a `git pull`** — no reinstall ever needed.

---

## 🚀 Installation (one-time setup)

```zsh
git clone <this-repo-url> ~/team-scripts
cd ~/team-scripts
zsh sh/install.zsh
source ~/.zshrc   # or open a new terminal
```

That's it. All scripts and aliases are now available in your shell.

---

## 🔄 Updating

```zsh
cd ~/team-scripts   # wherever you cloned the repo
git pull
```

No further action needed — the loader picks up new scripts automatically.

---

## 🗑️ Uninstalling

```zsh
zsh sh/uninstall.zsh
```

This removes the `source` block added to `~/.zshrc`.

---

## 📦 Available Script Groups

### `git-utils`

Git productivity aliases and functions.

| Command / Alias | Description |
|---|---|
| `gs` | Short `git status -sb` |
| `glog` | Pretty graph log |
| `gpush` | Push current branch |
| `gpull` | Pull with rebase |
| `gclean [base]` | Delete merged branches (default base: `main`) |
| `gnew <branch> [base]` | Create branch from latest base and push |
| `gundo` | Undo last commit, keep changes staged |

### `rabbitmq-utils`

RabbitMQ management helpers via the HTTP API. Requires `curl` and `jq`.

**Configuration** (optional overrides in your `~/.zshrc`):
```zsh
export RABBITMQ_HOST=http://my-rabbit:15672
export RABBITMQ_USER=admin
export RABBITMQ_PASS=secret
```

| Command | Description |
|---|---|
| `rmq-status` | Cluster overview |
| `rmq-queues` | List queues with message counts |
| `rmq-purge <queue>` | Purge all messages from a queue |
| `rmq-publish <queue> <msg>` | Publish a test message |

---

## ➕ Adding a New Script Group

1. Create a folder under `sh/`:
   ```
   sh/my-new-group/
   └── my-new-group.plugin.zsh
   ```
2. Write your aliases and functions inside `my-new-group.plugin.zsh`.
3. Commit and push.

The loader auto-discovers all `*.plugin.zsh` files — **no other changes needed**.

---

## 🗂️ Repository Structure

```
shell-scripts/
├── README.md
└── sh/
    ├── install.zsh          ← one-time installer
    ├── uninstall.zsh        ← removes the ~/.zshrc entry
    ├── loader.zsh           ← auto-sourced, discovers all plugins
    ├── git-utils/
    │   └── git-utils.plugin.zsh
    └── rabbitmq-utils/
        └── rabbitmq-utils.plugin.zsh
```

---

## 🔮 Roadmap

- [ ] PowerShell equivalents for Windows developers
- [ ] `docker-utils` group
- [ ] `k8s-utils` group
