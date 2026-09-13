# 🛠️ Team Shell Scripts

A centralized repository for shared shell scripts used across the development team.
Scripts are **grouped by domain** and available for both **zsh** and **PowerShell**.

---

## How it works

- Clone the repo **once**, run the installer for your shell.
- A single `source` / dot-source line is added to your shell profile.
- **Updates are just a `git pull`** — no reinstall ever needed.
- Scripts are grouped into plugins (e.g. `git-utils`, `rabbitmq-utils`).
  Adding a new group requires only a new file — no loader changes.

---

## 🐚 zsh (macOS / Linux)

```zsh
git clone <repo-url> ~/team-scripts
cd ~/team-scripts
zsh sh/install.zsh
source ~/.zshrc
```

➡️ See [`sh/README.md`](./sh/README.md) for available commands and how to add plugins.

---

## 💙 PowerShell (Windows / macOS / Linux)

```powershell
git clone <repo-url> ~/team-scripts
cd ~/team-scripts
pwsh ps/install.ps1
. $PROFILE
```

➡️ See [`ps/README.md`](./ps/README.md) for available commands and how to add plugins.

---

## 🔄 Updating (both shells)

```bash
cd ~/team-scripts && git pull
```

That's it — no reinstall needed.

---

## 🗂️ Repository Structure

```
shell-scripts/
├── README.md
├── sh/                              # zsh scripts
│   ├── README.md
│   ├── install.zsh                  ← one-time installer
│   ├── uninstall.zsh                ← clean removal
│   ├── loader.zsh                   ← auto-discovers *.plugin.zsh files
│   ├── git-utils/
│   │   └── git-utils.plugin.zsh
│   └── rabbitmq-utils/
│       └── rabbitmq-utils.plugin.zsh
└── ps/                              # PowerShell scripts
    ├── README.md
    ├── install.ps1                  ← one-time installer
    ├── uninstall.ps1                ← clean removal
    ├── loader.ps1                   ← auto-discovers *.plugin.ps1 files
    ├── git-utils/
    │   └── git-utils.plugin.ps1
    └── rabbitmq-utils/
        └── rabbitmq-utils.plugin.ps1
```

---

## 🔮 Roadmap

- [ ] `docker-utils` group
- [ ] `k8s-utils` group
- [ ] `aws-utils` group
