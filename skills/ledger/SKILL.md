---
name: ledger
description: 记账与统计。主人说"记一笔"、"这个月花了多少"、"吃饭花了多少"时用。
---
# 记账

## 何时使用
任何记录支出/收入、查询消费、汇总统计的请求。

## 输入
金额、分类、可选备注和日期。分类从主人的说法归一化为固定集合（如：餐饮、交通、购物、居住、娱乐、医疗、订阅、收入、其它），已有分类用 `hub-ledger sum` 看。

## 步骤
1. 记：`bin/hub-ledger add <金额> <分类> "<备注>" [--date YYYY-MM-DD]`。收入用负数。
2. 查：`bin/hub-ledger list --month YYYY-MM [--category X]`。
3. 统计：`bin/hub-ledger sum --month YYYY-MM [--by month]`。
4. 回复只给主人要的数字，不要贴整张表；表格需要时写文件回路径。

## 调用
`bin/hub-ledger add|list|sum|del|export`

## 限制与需确认项
- 删除条目前复述该条目再删。
- 分类拿不准时按最接近的已有分类记，并在回复里说明用了哪个分类。
- 不做任何理财建议。

## 完成判据
`add` 返回了 id；查询给出数字。
