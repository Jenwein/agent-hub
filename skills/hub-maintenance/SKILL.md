---
name: hub-maintenance
description: 修改 hub 自身：新增资源、改规则、沉淀新技能、改脚本。改完必须验证并提交。
---
# 维护 hub

## 何时使用
- 主人新增了机器、WSL、docker 或项目
- 一个任务做完发现值得沉淀成技能
- 主人要求改规则或脚本
- `hub-doctor` 报错

## 输入
要改什么，属于公开框架还是私有内容。判断标准：这个文件如果被陌生人看到，是否泄露主人信息或对他毫无用处；是则进 `private/`。

## 步骤
1. 资源：编辑 `private/resources.yaml`，字段说明见 `resources.example.yaml` 头部。层级名用 `/`。
2. 技能：按 `skills/README.md` 的模板新建目录和 `SKILL.md`，并在对应的 README 索引里加一行。
3. 规则：公共规则改 `rules/`，个人规则改 `private/rules/`。
4. 验证：`bin/hub-doctor`，新技能跑 `bin/hub-link-skills`。
5. 提交：改哪个仓库就在哪个目录 `git add -A && git commit -m "<msg>"`；push 属 L2。

## 调用
- `bin/hub-doctor`、`bin/hub-link-skills`
- `git`

## 限制与需确认项
- 改 `rules/`、`private/rules/`、`bin/`、`resources.yaml` 属 L3，先和主人商量改什么、为什么。
- 不把主人的机器名、路径、账号写进公开框架的任何文件。

## 完成判据
`hub-doctor` 无 ERR，改动已提交。
