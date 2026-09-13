# 💙 PowerShell Scripts

Shell scripts for **PowerShell** users (Windows / macOS / Linux with `pwsh`).

> **Requires:** PowerShell 7+ (`pwsh`). Most things also work on Windows PowerShell 5.1.

---

## 🚀 Installation (one-time)

```powershell
git clone <repo-url> ~/team-scripts
cd ~/team-scripts

# PowerShell 7 (pwsh) – all platforms
pwsh ps/install.ps1

# Windows PowerShell 5.1 (if pwsh is not available)
powershell -ExecutionPolicy Bypass -File ps\install.ps1
```

The installer adds a dot-source line to `$PROFILE.CurrentUserAllHosts`
(works on Windows, macOS and Linux) pointing to [`loader.ps1`](./loader.ps1).
All plugins are picked up automatically.

> **First-time execution policy (Windows only):**
> If you get a script-blocked error, run once as Administrator:
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```

## 🔄 Updating

```powershell
cd ~/team-scripts; git pull   # that's all
```

## 🗑️ Uninstalling

```powershell
pwsh ps/uninstall.ps1
```

---

## 📦 Plugins

### `git-utils`

> File: [`git-utils/git-utils.plugin.ps1`](./git-utils/git-utils.plugin.ps1)

| Alias / Function | Description |
|---|---|
| `gs` | `git status -sb` |
| `glog` | Pretty graph log |
| `gpush` | Push current branch to origin |
| `gpull` | Pull with rebase |
| `gclean [-Base main]` | Delete local branches merged into base |
| `gnew <branch> [-Base main]` | Create branch from latest base and push |
| `gundo` | Undo last commit, keep changes staged |

PowerShell verb-noun equivalents are also available:

| Alias | Full function name |
|---|---|
| `gclean` | `Invoke-GitClean` |
| `gnew` | `Invoke-GitNew` |
| `gundo` | `Invoke-GitUndo` |

### `rabbitmq-utils`

> File: [`rabbitmq-utils/rabbitmq-utils.plugin.ps1`](./rabbitmq-utils/rabbitmq-utils.plugin.ps1)

Uses `Invoke-RestMethod` (built into PowerShell) — no extra dependencies.

**Optional env var overrides** (add to your `$PROFILE`):
```powershell
$env:RABBITMQ_HOST  = 'http://my-rabbit:15672'
$env:RABBITMQ_USER  = 'admin'
$env:RABBITMQ_PASS  = 'secret'
$env:RABBITMQ_VHOST = '%2F'
```

| Alias | Full function name | Description |
|---|---|---|
| `rmq-status` | `Get-RmqStatus` | Cluster overview |
| `rmq-queues` | `Get-RmqQueues` | List queues with counts |
| `rmq-purge` | `Clear-RmqQueue` | Purge all messages from a queue |
| `rmq-publish` | `Send-RmqMessage` | Publish a test message |

Usage examples:
```powershell
rmq-queues
rmq-purge -QueueName my-queue
rmq-publish -QueueName my-queue -Message 'hello world'
```

---

## ➕ Adding a New Plugin Group

1. Create `ps/<group-name>/<group-name>.plugin.ps1`
2. Write your functions (and optional `Set-Alias`) inside it
3. Commit and push — the loader discovers it automatically

```
ps/
└── my-new-group/
    └── my-new-group.plugin.ps1   <- add this
```

### PowerShell naming conventions to follow

| Type | Convention | Example |
|---|---|---|
| Functions | `Verb-Noun` | `Get-RmqQueues` |
| Aliases | `short-name` | `rmq-queues` |
| Private helpers | `script:` scope | `script:Invoke-RmqApi` |
