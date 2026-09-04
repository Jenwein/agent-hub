---
name: task
description: 跟踪多步任务，跨会话接续。会话开始先看有没有没做完的。
---
# 任务

## 何时使用
- 一件事一次会话做不完
- 在等主人或外部条件（waiting）
- 主人要"待办清单"

## 输入
标题，进度说明。

## 步骤
1. 会话开始：`bin/hub-task list`，有 doing/waiting 的先向主人提一句。
2. 开始一件多步任务：`add`，然后 `set <id> --status doing`。需要现场的按 `rules/30-workflow.md` 用 `bin/hub-work new` 建目录，并 `--append "现场在 work/<目录名>"`。
3. 每完成一个阶段：`set <id> --append "<做到哪、下一步是什么、关键路径或命令>"`，写得让下个会话的你能直接接着做。
4. 等主人：`set <id> --status waiting --append "等主人确认 X"`。
5. 完成：`done <id>`。

## 调用
`bin/hub-task add|list|show|set|done|del`

## 限制与需确认项
- notes 里不放密钥。
- 不替主人决定任务优先级，列出来让主人选。

## 完成判据
任务状态与实际一致。
