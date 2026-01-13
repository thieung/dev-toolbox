#!/bin/sh
# Install happy-ccs globally (cross-platform for Mac/Linux)
set -e

echo "Installing happy-ccs..."

# Check and install prerequisites if needed
if ! command -v ccs >/dev/null 2>&1; then
    echo "Installing CCS CLI..."
    npm install -g @kaitranntt/ccs || true
fi

if ! command -v happy >/dev/null 2>&1; then
    echo "Installing Happy CLI..."
    npm install -g happy-coder || true
fi

# Remove old installation if exists
npm uninstall -g happy-ccs 2>/dev/null || true

# Install dependencies and global package
npm install
npm install -g .

echo ""
echo "Done! Run 'happy-ccs --help' to get started."
echo ""
echo "If 'command not found', restart your terminal or run:"
echo "  Bash/Zsh: hash -r"
echo "  Fish:     functions -e happy-ccs"
