# Codex Computer Use recovery

Recovery script and root-cause note for the Codex App issue where **Computer use** or Chrome control stays disabled after restarting the app.

Vietnamese version: [README.vi.md](./README.vi.md)

## Summary

The local setup can be repaired temporarily, but Codex App may undo that repair on every startup.

The observed root cause is not the standalone Codex install command:

```bash
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

The root cause is that Codex App resolves Browser/Computer Use availability as disabled from the app-side feature gate or account entitlement. On startup, Codex App treats that server-side state as source of truth, then reconciles local bundled plugins back to the allowed list.

Observed log evidence:

```text
browser_use_availability_resolved available=false reason=statsig-disabled
bundled_plugins_runtime_marketplace_written pluginCount=1 pluginNames=["latex"]
bundled_plugin_uninstall_requested pluginId=chrome@openai-bundled reason=not_in_bundled_marketplace_plugin_names
bundled_plugin_uninstall_requested pluginId=computer-use@openai-bundled reason=not_in_bundled_marketplace_plugin_names
```

In plain terms:

- The CLI workaround can re-add `chrome@openai-bundled` and `computer-use@openai-bundled`.
- The manual MCP entry can make `computer-use` available to Codex threads.
- But when Codex App is quit and opened again, the app runs startup reconciliation.
- If the app still receives `reason=statsig-disabled`, it rewrites the bundled marketplace to only `latex`.
- Then it uninstalls or disables `chrome` and `computer-use` again.

That is why the workaround is reset after every Codex App restart.

## Is this an OpenAI bug?

If the account/workspace is supposed to have Computer Use, this looks like an OpenAI-side rollout, feature flag, or entitlement bug.

It is not proven to be a product bug in all cases because the same symptoms can also happen when the feature is intentionally unavailable due to account policy, organization policy, region, or staged rollout.

The most accurate support wording:

> Codex App disables Computer Use after restart because Browser/Computer Use availability resolves as `statsig-disabled`. On startup, the app reconciles bundled plugins to only `latex` and uninstalls `chrome@openai-bundled` plus `computer-use@openai-bundled`.

## Workaround

After opening Codex App, run:

```bash
./scripts/recover-computer-use-after-restart.sh
```

Then start a new Codex thread so the MCP server and plugin state are loaded in the new session.

The script:

- resets the `openai-bundled` marketplace to the bundled marketplace inside `/Applications/Codex.app`
- re-adds `chrome@openai-bundled`
- re-adds `computer-use@openai-bundled`
- refreshes the manual `computer-use` MCP server

This script does not force the disabled Settings toggle to turn on. If the app still receives `statsig-disabled`, the Settings UI can remain disabled. The workaround only restores the local CLI/MCP path after startup reconciliation has already run.

## Requirements

- macOS
- Codex App installed at `/Applications/Codex.app`
- `codex` CLI available on `PATH`
- Computer Use helper installed at:

```text
~/.codex/computer-use/Codex Computer Use.app/Contents/SharedSupport/SkyComputerUseClient.app/Contents/MacOS/SkyComputerUseClient
```

## Verify

After running the script, verify:

```bash
codex plugin list
codex mcp list
```

Expected local state:

```text
chrome@openai-bundled        installed, enabled
computer-use@openai-bundled  installed, enabled
computer-use                 enabled
```

If Codex App is restarted, run the script again.

## Support payload

When reporting to OpenAI support, include these log lines:

```text
browser_use_availability_resolved available=false reason=statsig-disabled
bundled_plugins_runtime_marketplace_written pluginCount=1 pluginNames=["latex"]
bundled_plugin_uninstall_requested pluginId=chrome@openai-bundled reason=not_in_bundled_marketplace_plugin_names
bundled_plugin_uninstall_requested pluginId=computer-use@openai-bundled reason=not_in_bundled_marketplace_plugin_names
```

Unresolved questions:

- Is the account/workspace expected to have Computer Use enabled?
- Is this a temporary staged rollout state or a persistent entitlement/config issue?
