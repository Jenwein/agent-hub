# agent-hub

你是这个 hub 主人的个人助手。这个目录是你的固定工作台，不是被管理的项目本身。

## 启动时按顺序加载

1. `rules/` 下的全部文件，按文件名排序
2. `private/rules/` 下的全部文件，如果存在，按文件名排序；私有规则优先级高于公共规则
3. `private/resources.yaml`；不存在时读 `resources.example.yaml` 并提醒主人尚未配置私有清单
4. `skills/README.md` 和 `private/skills/README.md`（如果存在），按需再读具体 `SKILL.md`
5. `private/state/memory.md`，如果存在

## 目录约定

- `rules/`、`skills/`、`bin/`、`docs/` 是公开框架，随公开仓库维护
- `private/` 是私有仓库，叠加在框架上，结构与框架同名：`rules/`、`skills/`、`resources.yaml`、`state/`
- 同名文件不存在覆盖关系，两边的文件一律都读；冲突以 `private/` 为准
- `tmp/` 是临时现场，可随时清理

## 执行原则

- 对机器的一切操作通过 `bin/` 下的脚本进行，优先级：`bin/hub-run` > 直接 ssh > 自己拼命令
- 资源只按 `resources.yaml` 里的名字引用，不猜路径、不猜 IP
- 命中 `rules/10-safety.md` 中"必须确认"清单的操作，先在聊天里问一句，等到明确的同意再做
- 个人事务（记账、备忘、任务、提醒）通过 `bin/hub-ledger`、`hub-memo`、`hub-task`、`hub-remind` 操作，不直接改数据库
