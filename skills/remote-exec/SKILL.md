---
name: remote-exec
description: 在 resources.yaml 里的任意资源上执行命令。所有涉及机器操作的技能都以此为基础。
---
# 远程执行

## 何时使用
需要在某台机器、WSL、docker 上跑任何命令时。不要自己写 ssh、wsl.exe、docker --context。

## 输入
- 资源名或别名（`bin/hub-res list` 可查）
- 要执行的命令。Windows 资源收到的是 PowerShell，其它是 bash

## 步骤
1. `bin/hub-res resolve <别名>` 确认资源名；歧义时反问。
2. `bin/hub-check <name>`；离线则如实汇报，不重试。
3. `bin/hub-run <name> '<命令>'`。命令用单引号整体传入。
4. 超过三行的逻辑先写到 `tmp/` 下的脚本，再用 `hub-run` 把脚本内容通过 `bash -s` 或 PowerShell 读入执行。

## 调用
- `bin/hub-res list|get|resolve`
- `bin/hub-check <name>`
- `bin/hub-run <name> '<cmd>'`
- `HUB_CONFIRMED=1 bin/hub-run ...`：仅在主人明确确认 L3 操作后

## 限制与需确认项
- `hub-run` 命中 `bin/lib/blocklist.txt` 会以退出码 86 拒绝。此时按 `rules/10-safety.md` 向主人确认，得到确认后再加 `HUB_CONFIRMED=1`。
- Windows 资源隔着 SSH 做不了 GUI 操作和需要交互的命令。
- 单条命令默认无超时；长任务要用 `timeout` 或后台化。

## 完成判据
命令退出码为 0，且用只读命令验证了预期效果。
