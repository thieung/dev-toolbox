# Happy-CCS

Cross-platform bridge between [CCS](https://github.com/kaitranntt/ccs) profiles and [Happy CLI](https://github.com/slopus/happy).

Switch between AI providers (Gemini, GLM, Kimi, etc.) while retaining all Happy CLI features (mobile control, daemon mode, notifications, auth management).

**[Tiếng Việt](README-VN.md)**

## Prerequisites

**Required:** [Node.js](https://nodejs.org) (with npm) and [Claude Code](https://code.claude.com/docs/en/setup) must be installed.

The install script will automatically install these CLI tools if missing:
- **[CCS](https://github.com/kaitranntt/ccs)**
- **[Happy CLI](https://github.com/slopus/happy)**

## Installation

### Quick Install

```bash
# Mac/Linux
curl -fsSL https://raw.githubusercontent.com/thieung/dev-toolbox/main/happy-ccs/install.sh | sh

# Windows PowerShell (run as Administrator if needed)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/thieung/dev-toolbox/main/happy-ccs/install.ps1 | iex"
```

### From Local Checkout

```bash
git clone https://github.com/thieung/dev-toolbox.git
cd dev-toolbox/happy-ccs

# Mac/Linux
./install.sh

# Windows PowerShell
.\install.ps1

# Windows CMD (run as Administrator if needed)
install.cmd
```

## Setup

1. **Navigate to your project folder:**
   ```bash
   cd /path/to/your/project
   ```

2. **Authenticate with your mobile device:**
   ```bash
   happy auth login          # First time
   happy auth login --force  # Re-authenticate
   ```

3. **Start coding with your preferred AI provider:**
   ```bash
   happy-ccs <profile>
   ```

## Usage

```bash
happy-ccs --list              # List available profiles
happy-ccs gemini              # Start with Gemini
happy-ccs glm --resume        # Resume session with GLM
happy-ccs kimi daemon start   # Daemon mode with Kimi
happy-ccs gemini --dry-run    # Test (shows command without running)
```

## Uninstall

```bash
npm uninstall -g happy-ccs
```
