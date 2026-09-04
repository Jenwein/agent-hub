# agent-hub

一个个人 Agent 系统的"总站"：Coding Agent（Codex、Claude Code 等）的固定工作目录，里面放规则、资源清单、技能和脚本。配合 [cc-connect](https://github.com/chenhg5/cc-connect) 把 agent 接到 IM，就能在手机上用自然语言管理自己的电脑、WSL、服务器、docker、git 项目和个人事务。

## 它是什么

- **一个目录**，agent 启动时 cwd 指向它，先读规则再干活
- **公开框架 + 私有叠加**：本仓库是框架，你的机器、偏好、数据放在被 gitignore 的 `private/` 里（通常是另一个私有仓库）
- **agent 无关**：`AGENTS.md`（Codex）和 `CLAUDE.md`（Claude Code）内容相同，规则和技能是纯文本
- **确定性操作交给脚本**：`bin/hub-run` 统一了 SSH、WSL、docker 的执行路径，并有黑名单和审计日志

## 结构

```
AGENTS.md / CLAUDE.md   agent 入口：加载顺序和执行原则
rules/                  行为规则、操作分级、资源用法、任务流程、记忆
resources.example.yaml  资源清单格式示例（真实清单在 private/resources.yaml）
skills/                 技能，每个一个 SKILL.md
bin/                    脚本：hub-run、hub-check、hub-res、hub-safe-rm、hub-doctor、
                        hub-ledger、hub-memo、hub-task、hub-remind、hub-backup、hub-sync
docs/                   设计文档、部署步骤
private/                gitignore；你的规则、清单、技能、运行状态
tmp/                    临时现场
```

## 快速开始

1. 把这个仓库 clone 到常开机器上，例如 `~/hub`
2. 建 `private/`（建议是你自己的私有仓库 clone 到这里），放入 `resources.yaml`，格式照 `resources.example.yaml`
3. 装依赖并初始化，见 [docs/setup.md](docs/setup.md)
4. 按 cc-connect 官方文档配置，`work_dir` 指向 `~/hub`
5. `bin/hub-doctor` 全绿即可

设计思路和取舍见 [docs/design.md](docs/design.md)。

## License

MIT
