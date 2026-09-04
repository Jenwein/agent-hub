---
name: reminder
description: 定时提醒，到点通过 Discord webhook 通知主人。
---
# 提醒

## 何时使用
主人说"X 点提醒我"、"明天提醒我"、"半小时后叫我"。

## 输入
时间（绝对时间、今天/明天/后天 + 时刻、或 +30m/+2h/+1d）和内容。

## 步骤
1. `bin/hub-remind add "<时间>" "<内容>"`，回复确认解析出的具体时间。
2. 查：`bin/hub-remind list`。
3. 投递由服务器 cron 每分钟执行 `hub-remind due --notify` 完成，不需要你做。如果主人说没收到提醒，检查 `crontab -l` 和 `private/resources.yaml` 的 `services.discord_webhook`。

## 调用
`bin/hub-remind add|list|due|del`

## 限制与需确认项
- 时间歧义（"周五"是这周还是下周）先反问。
- 周期性提醒当前不支持，如实说明；可以一次性建多条。

## 完成判据
`add` 返回 id 和时间。
