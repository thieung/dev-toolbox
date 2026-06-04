#!/usr/bin/env bash
set -euo pipefail

bundled_root="${CODEX_BUNDLED_MARKETPLACE_ROOT:-/Applications/Codex.app/Contents/Resources/plugins/openai-bundled}"
computer_use_client="${CODEX_COMPUTER_USE_CLIENT:-$HOME/.codex/computer-use/Codex Computer Use.app/Contents/SharedSupport/SkyComputerUseClient.app/Contents/MacOS/SkyComputerUseClient}"

if ! command -v codex >/dev/null 2>&1; then
  echo "codex CLI not found on PATH" >&2
  exit 1
fi

if [[ ! -d "$bundled_root" ]]; then
  echo "Codex App bundled plugin marketplace not found: $bundled_root" >&2
  exit 1
fi

echo "Resetting openai-bundled marketplace to Codex.app resources..."
codex plugin marketplace remove openai-bundled >/dev/null 2>&1 || true
codex plugin marketplace add "$bundled_root"

echo "Re-adding Chrome and Computer Use bundled plugins..."
codex plugin add chrome@openai-bundled
codex plugin add computer-use@openai-bundled

if [[ -x "$computer_use_client" ]]; then
  echo "Refreshing manual computer-use MCP server..."
  codex mcp remove computer-use >/dev/null 2>&1 || true
  codex mcp add computer-use -- "$computer_use_client" mcp
else
  echo "Computer Use client not found: $computer_use_client" >&2
  echo "Skipping MCP refresh." >&2
fi

echo
echo "Current openai-bundled plugin state:"
codex plugin list | awk '
  /^Marketplace `openai-bundled`/ { show = 1 }
  /^Marketplace `/ && show && $0 !~ /openai-bundled/ { show = 0 }
  show { print }
'

echo
echo "Current computer-use MCP state:"
codex mcp list | sed -n '/computer-use/p'

echo
echo "Done. Start a new Codex thread after running this."
echo "If Settings still says disabled, that is the app/account feature gate, not this local repair script."
