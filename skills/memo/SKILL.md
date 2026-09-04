---
name: memo
description: 备忘：记下一句话、以后按关键词或标签找回。
---
# 备忘

## 何时使用
主人说"记一下"、"备忘"、"之前我说过的那个 X 是什么"。和长期记忆的区别：备忘是主人的事，记忆是关于主人的事。

## 输入
内容，可选标签。

## 步骤
1. `bin/hub-memo add "<内容>" --tags a,b`
2. 找回：`bin/hub-memo search <关键词>` 或 `list --tag X`
3. 过期的 `archive`，主人明确要删的 `del`

## 调用
`bin/hub-memo add|list|search|archive|del`

## 限制与需确认项
- 不把密码、token 记进备忘；主人给了就提醒放到密码管理器，备忘只写"在哪里"。

## 完成判据
返回 id 或找到条目。
