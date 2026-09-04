# 设计

## 目标

一个长期可用的个人 Agent 系统：通过 IM 发自然语言，agent 帮忙管理本地电脑、WSL、服务器、docker、git 项目、文件和个人事务。系统有固定的总站，agent 共享统一的规则、资源信息、技能和状态。

## 四个部件

| 部件 | 职责 | 在哪 |
|------|------|------|
| cc-connect | IM 到 agent 的管道：收消息、会话、排队、取消 | 常开机器，配置在 `~/.cc-connect/` |
| Agent Runtime | 理解意图、选技能、执行、汇报 | 常开机器，cwd 是 hub |
| agent-hub | 规则、资源清单、技能、脚本、状态 | 本仓库 + `private/` |
| 被管理资源 | 电脑、WSL、服务器、docker、项目、外部服务 | 各处，通过 `resources.yaml` 命名 |

cc-connect 对资源、规则、技能一无所知，它只负责把消息送到 agent。hub 才是控制面。

## 多机协同：单主脑

只有一台机器常开时，cc-connect 和 agent 只在那台机器上跑，hub 只有一份，其它机器全部是"被管理资源"，由主脑通过网络触达。

- **网络**：Tailscale（官方版）。不常开、在 NAT 后的机器一开机就自动上线，主脑用固定名字 `ssh desktop` 直达，无需公网 IP。
- **Windows**：开启系统自带 OpenSSH Server，默认 shell 设为 PowerShell。`hub-run` 用 `-EncodedCommand` 传命令，绕过多层引号问题。
- **WSL**：不单独联网，通过宿主 Windows 的 SSH 再 `wsl.exe -d <distro>`。命令用 base64 传入。
- **docker**：在哪台机器就归哪台，通过那台机器执行 `docker`，不暴露 socket。
- **离线是常态**：每个资源有 `always_on` 标记，`hub-check` 秒级判断，离线直接汇报不重试。
- **git 项目**：本体在哪台机器就在哪台改，跨机只走 push/pull。清单只记录每个项目在各机器的路径。

以后若发现某类操作必须在本机做（GUI 等），可以在那台机器再跑一个 cc-connect + agent，clone 同一份 hub，IM 上用另一个 bot。到那时再考虑状态同步。

## 资源模型：两层

- **机器**：能 SSH 到达的东西，`reach: ssh|local`
- **环境**：机器上的命名子对象（WSL、docker），`via: <父资源>`，可以多层嵌套

名字用 `/` 表示层级：`desktop`、`desktop/wsl`、`desktop/wsl/docker`。一台机器多个 WSL 或 docker 就是多条记录，各自起名。`hub-run` 顺着 `via` 链拼出真正的执行链，技能只说"在 X 上执行"，不关心中间几跳。

## 公开框架 + 私有叠加

两个仓库按目录叠加，文件永不重叠，各自独立提交，不需要 merge，也不会把私有内容误推到公开仓库。

```
hub/            公开：AGENTS.md rules/ skills/ bin/ docs/ resources.example.yaml
hub/private/    私有（gitignore）：rules/ skills/ resources.yaml state/
```

加载顺序在 `AGENTS.md`：先公共规则，再私有规则，私有优先。私有目录不存在时系统仍能跑，这正是别人 clone 下来的初始状态。

划分标准：一个文件如果被陌生人看到会泄露信息或对他毫无用处，就是私有的。

`private/state/` 是运行时数据（SQLite、记忆、审计日志），由 agent 直接写，在私有仓库里也 gitignore，靠 `hub-backup` 定期打包。git 里只放人写的东西。

## 权限

cc-connect 开 yolo，否则 IM 里每条工具调用都要点确认没法用。分级和确认清单写在 `rules/10-safety.md`，靠 agent 判断。再加一层不依赖 agent 自觉的护栏：

- `hub-run` 拦截 `bin/lib/blocklist.txt` 里的模式，需 `HUB_CONFIRMED=1` 放行
- `hub-safe-rm` 把删除变成移动到 `~/.hub-trash/<日期>/`
- 所有 `hub-run` 调用记入 `private/state/logs/hub-run.log`

## 个人事务

记账、备忘、任务、提醒各一个薄脚本，数据在 `private/state/hub.db`（SQLite 单文件）。选 SQLite 而不是文本的原因：agent 只调脚本不碰存储，写入原子；查询汇总一句 SQL；备份是复制一个文件；随时 `export` 成 CSV 给别的工具。长期记忆是给 agent 读的文本，仍是 `memory.md`。

## 任务现场

非平凡任务各自一个目录 `private/state/work/<日期>-<slug>/`，里面只有 `task.md`（请求原话、计划、结果，原地追加）和自由放置的 `evidence/`。刻意做得很轻：agent 的负担只是建目录和追加一个文件。任务摘要不另存，归宿是 `hub-task` 的 notes；执行了什么由 `hub-run` 审计日志记录。证据 30 天后清理，`task.md` 保留。

提醒的投递靠服务器 cron 每分钟 `hub-remind due --notify` 打 Discord webhook。

## 依赖与取舍

- 脚本用 bash + yq 而不是 Python 框架：只在服务器跑，够用且透明。个人事务用 Python 标准库 sqlite3，无第三方依赖。
- 不用 Headscale：数据面都是 WireGuard 直连，自建只是把控制面搬到自己服务器上，多一个要维护的服务，服务器内存本来就紧。
- 不用现成记账应用：交互全在 IM 里，现成应用的 UI 和分类体系用不上，自己掌握数据随时可导出。
