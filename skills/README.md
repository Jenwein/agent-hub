# Skills 索引

每个技能一个目录，`SKILL.md` 固定六段：何时使用、输入、步骤、调用的脚本或命令、限制与需确认项、完成判据。
步骤只引用 `bin/` 脚本或明确的 CLI，不写"根据情况生成命令"。私有技能放 `private/skills/`，同样格式，索引在 `private/skills/README.md`。

| 技能 | 用途 |
|------|------|
| `remote-exec` | 基础原语：在任意资源上执行命令。其它技能都建立在它之上 |
| `windows` | Windows 机器的常见管理：进程、服务、磁盘、软件、计划任务 |
| `wsl` | WSL 发行版的管理与在其中执行 |
| `linux-server` | 服务器运维：systemd、日志、磁盘、cron、包 |
| `docker` | 容器与 compose 的查看、启停、日志、更新 |
| `git` | 跨机器的 git 项目操作：状态、同步、提交、分支 |
| `files` | 跨机器找文件、搬文件、看空间、清理 |
| `ledger` | 记账与统计 |
| `memo` | 备忘 |
| `task` | 多步任务的跟踪与跨会话接续 |
| `reminder` | 定时提醒 |
| `backup` | 备份 hub 状态与主人指定的目录 |
| `hub-maintenance` | 修改 hub 自身：资源清单、规则、技能、脚本 |

## SKILL.md 模板

```markdown
---
name: <name>
description: <一句话，什么情况下用>
---
# <标题>

## 何时使用
## 输入
## 步骤
## 调用
## 限制与需确认项
## 完成判据
```
