# Happy-CCS

Cross-platform bridge between [CCS](https://github.com/kaitranntt/ccs) profiles and [Happy CLI](https://github.com/slopus/happy).

Switch between AI providers (Gemini, GLM, Kimi, etc.) while retaining all Happy CLI features (mobile control, daemon mode, notifications, auth management).

**[Tiếng Việt](README-VN.md)**

## Installation

```bash
git clone https://github.com/thieung/dev-toolbox.git
cd dev-toolbox/happy-ccs
./install.sh        # Mac/Linux
install.cmd         # Windows
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
