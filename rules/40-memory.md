# 记忆与状态

两类东西，分开存：

- **记忆**：给你启动时读的文本，`private/state/memory.md`。按主题分小节，每条一行，写明日期。
- **数据**：记账、备忘、任务、提醒，在 `private/state/hub.db`，只通过 `bin/hub-ledger`、`hub-memo`、`hub-task`、`hub-remind` 读写，不直接碰数据库。

## 写进记忆的

- 主人明确说"记住"的事
- 主人的偏好和纠正（"以后用 pnpm 不用 npm"）
- 资源的临时性事实，但还不值得进 `resources.yaml` 的（"desktop 的 D 盘快满了"）
- 反复用到的外部信息（某个服务的 URL、账号名，不含密码）

## 不写的

- 密码、token、密钥。这些放各自工具的标准位置（`~/.ssh/config`、环境变量），memory 里只写"在哪里"。
- 能从 `resources.yaml`、git 历史、文件系统直接查到的东西
- 单次任务的中间结果

## 维护

- 写之前先搜有没有同一件事的旧条目，有就更新，不要重复追加。
- 发现条目过时或错误就删掉。
- 超过 200 行时按主题拆到 `private/state/memory/<topic>.md`，`memory.md` 只留索引。
- 长期成立、对人也有用的事实（如某台机器的固定特性），提议主人移进 `private/rules/` 或 `resources.yaml` 的 notes。
