#!/bin/sh
# Install happy-ccs globally (cross-platform for Mac/Linux)
set -e

echo "Installing happy-ccs..."

REPO_ARCHIVE_URL="${HAPPY_CCS_ARCHIVE_URL:-https://github.com/thieung/dev-toolbox/archive/refs/heads/main.tar.gz}"
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" 2>/dev/null && pwd)
INSTALL_DIR="$SCRIPT_DIR"
TEMP_DIR=""

cleanup() {
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
}
trap cleanup EXIT HUP INT TERM

download_archive() {
    archive_path="$1"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$REPO_ARCHIVE_URL" -o "$archive_path"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "$archive_path" "$REPO_ARCHIVE_URL"
    else
        echo "Error: curl or wget is required for quick install."
        exit 1
    fi
}

is_happy_ccs_package() {
    [ -f "$1/package.json" ] &&
        [ -f "$1/scripts/happy-ccs.mjs" ] &&
        grep -q '"name"[[:space:]]*:[[:space:]]*"happy-ccs"' "$1/package.json"
}

if ! is_happy_ccs_package "$INSTALL_DIR"; then
    echo "Downloading happy-ccs package..."
    TEMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t happy-ccs)
    ARCHIVE_PATH="$TEMP_DIR/dev-toolbox.tar.gz"
    download_archive "$ARCHIVE_PATH"
    tar -xzf "$ARCHIVE_PATH" -C "$TEMP_DIR"
    INSTALL_DIR=$(find "$TEMP_DIR" -maxdepth 3 -type d -name happy-ccs | head -n 1)
    if [ -z "$INSTALL_DIR" ] || ! is_happy_ccs_package "$INSTALL_DIR"; then
        echo "Error: could not find happy-ccs package in downloaded archive."
        exit 1
    fi
fi

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
cd "$INSTALL_DIR"
npm install
npm install -g .

echo ""
echo "Done! Run 'happy-ccs --help' to get started."
echo ""
echo "If 'command not found', restart your terminal or run:"
echo "  Bash/Zsh: hash -r"
echo "  Fish:     functions -e happy-ccs"
