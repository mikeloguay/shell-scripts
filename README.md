# Team Shell Scripts

Shared shell scripts and aliases for **zsh** and **PowerShell**.

## Quick Start

### zsh

```zsh
zsh sh/install.zsh
source ~/.zshrc
```

### PowerShell

```powershell
pwsh ps/install.ps1
. $PROFILE
```

## Updates

```bash
git pull
```

## Structure

```
.
├── sh/
│   ├── install.zsh
│   ├── uninstall.zsh
│   ├── loader.zsh
│   └── git-utils/git-utils.plugin.zsh
└── ps/
    ├── install.ps1
    ├── uninstall.ps1
    ├── loader.ps1
    └── git-utils/git-utils.plugin.ps1
```
