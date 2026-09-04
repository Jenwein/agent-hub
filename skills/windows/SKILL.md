---
name: windows
description: 管理 Windows 机器：进程、服务、磁盘、已装软件、计划任务、网络。
---
# Windows 管理

## 何时使用
主人要查看或操作 Windows 台式机 / 笔记本上的系统层面事务。

## 输入
资源名（type 为 windows），要做的事。

## 步骤
1. `bin/hub-check <name>`，离线直接汇报。
2. 用下表的 PowerShell 命令通过 `bin/hub-run` 执行。
3. 修改类操作做完用对应查询命令验证。

## 调用
| 目的 | 命令 |
|------|------|
| 概况 | `Get-ComputerInfo \| Select OsName,OsUptime,CsTotalPhysicalMemory` |
| 磁盘 | `Get-PSDrive -PSProvider FileSystem \| Select Name,@{n='UsedGB';e={[math]::Round($_.Used/1GB,1)}},@{n='FreeGB';e={[math]::Round($_.Free/1GB,1)}}` |
| 进程 Top | `Get-Process \| Sort CPU -Desc \| Select -First 10 Name,Id,CPU,WS` |
| 结束进程 | `Stop-Process -Name <n> -Force` |
| 服务 | `Get-Service <n>` / `Start-Service` / `Stop-Service` / `Restart-Service` |
| 已装软件 | `winget list` |
| 装/升级软件 | `winget install --id <id> -e --silent` / `winget upgrade --all` |
| 计划任务 | `Get-ScheduledTask \| Where State -ne Disabled \| Select TaskName,State` |
| 网络 | `Get-NetIPAddress -AddressFamily IPv4 \| Select InterfaceAlias,IPAddress` |
| Tailscale | `tailscale status` |

## 限制与需确认项
- 关机、重启、休眠属 L3（黑名单已拦截），必须确认。
- 修改注册表、防火墙、系统环境变量属 L3。
- 需要管理员权限的命令若失败，说明 SSH 会话未提权，如实汇报，不要尝试绕过 UAC。
- 装软件、升级软件是 L1，做之前说一声要装什么。

## 完成判据
查询类给出结果；修改类用查询命令确认状态已变。
