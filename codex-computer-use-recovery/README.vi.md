# Codex Computer Use recovery

Post + workaround cho lỗi Codex App hiển thị **Computer use** hoặc Chrome control bị disabled sau khi restart app.

English version: [README.md](./README.md)

## Tóm tắt

Local setup có thể repair tạm thời, nhưng Codex App có thể tự undo phần repair đó sau mỗi lần startup.

Root cause quan sát được không phải do lệnh cài standalone Codex:

```bash
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

Root cause là Codex App đang resolve availability của Browser/Computer Use thành disabled từ feature gate hoặc account entitlement phía App/OpenAI. Khi startup, Codex App coi trạng thái server-side này là source of truth, rồi reconcile local bundled plugins về đúng danh sách được allow.

Bằng chứng trong log:

```text
browser_use_availability_resolved available=false reason=statsig-disabled
bundled_plugins_runtime_marketplace_written pluginCount=1 pluginNames=["latex"]
bundled_plugin_uninstall_requested pluginId=chrome@openai-bundled reason=not_in_bundled_marketplace_plugin_names
bundled_plugin_uninstall_requested pluginId=computer-use@openai-bundled reason=not_in_bundled_marketplace_plugin_names
```

Nói ngắn gọn:

- CLI workaround có thể re-add `chrome@openai-bundled` và `computer-use@openai-bundled`.
- Manual MCP entry có thể làm `computer-use` available trong Codex thread.
- Nhưng khi quit Codex App và mở lại, app chạy startup reconciliation.
- Nếu app vẫn nhận `reason=statsig-disabled`, nó rewrite bundled marketplace chỉ còn `latex`.
- Sau đó app uninstall hoặc disable lại `chrome` và `computer-use`.

Đây là lý do workaround bị reset sau mỗi lần restart Codex App.

## Đây có phải bug của OpenAI không?

Nếu account/workspace lẽ ra phải có Computer Use, thì đây trông giống OpenAI-side rollout, feature flag, hoặc entitlement bug.

Không thể khẳng định 100% là product bug trong mọi trường hợp, vì cùng symptom này cũng có thể xảy ra khi feature bị disable có chủ đích do account policy, organization policy, region, hoặc staged rollout.

Wording chính xác nhất để report support:

> Codex App disables Computer Use after restart because Browser/Computer Use availability resolves as `statsig-disabled`. On startup, the app reconciles bundled plugins to only `latex` and uninstalls `chrome@openai-bundled` plus `computer-use@openai-bundled`.

## Workaround

Sau khi mở Codex App, chạy script:

```bash
./scripts/recover-computer-use-after-restart.sh
```

Sau đó start một Codex thread mới để MCP server và plugin state được load vào session mới.

Script sẽ:

- reset `openai-bundled` marketplace về bundled marketplace nằm trong `/Applications/Codex.app`
- re-add `chrome@openai-bundled`
- re-add `computer-use@openai-bundled`
- refresh manual `computer-use` MCP server

Script này không ép được disabled toggle trong Settings bật lên. Nếu app vẫn nhận `statsig-disabled`, Settings UI vẫn có thể disabled. Workaround chỉ restore local CLI/MCP path sau khi startup reconciliation đã chạy xong.

## Requirements

- macOS
- Codex App installed ở `/Applications/Codex.app`
- `codex` CLI available trong `PATH`
- Computer Use helper installed ở:

```text
~/.codex/computer-use/Codex Computer Use.app/Contents/SharedSupport/SkyComputerUseClient.app/Contents/MacOS/SkyComputerUseClient
```

## Verify

Sau khi chạy script, verify:

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

Nếu restart Codex App, chạy script lại.

## Support payload

Khi report OpenAI support, gửi kèm các log lines này:

```text
browser_use_availability_resolved available=false reason=statsig-disabled
bundled_plugins_runtime_marketplace_written pluginCount=1 pluginNames=["latex"]
bundled_plugin_uninstall_requested pluginId=chrome@openai-bundled reason=not_in_bundled_marketplace_plugin_names
bundled_plugin_uninstall_requested pluginId=computer-use@openai-bundled reason=not_in_bundled_marketplace_plugin_names
```
