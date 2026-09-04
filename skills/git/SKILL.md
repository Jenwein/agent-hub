---
name: git
description: 操作各机器上的 git 项目：状态、拉推、提交、分支。项目位置来自 resources.yaml 的 projects 段。
---
# Git 项目

## 何时使用
主人提到某个项目名，或要同步、提交、查看某个仓库。

## 输入
项目名（`bin/hub-res projects` 可查），可选的机器名；没说机器时用该项目 locations 里在线的第一个。

## 步骤
1. `bin/hub-res projects` 找到项目在哪些机器的哪个路径。
2. `bin/hub-check <机器>`。
3. `bin/hub-run <机器> 'cd <path> && git <...>'`。Windows 上用 `Set-Location <path>; git <...>`。
4. 汇报时带上分支名和最近一条提交。

## 调用
- 状态：`git status -sb && git log --oneline -5`
- 同步：`git pull --ff-only`、`git push`
- 提交：`git add -A && git commit -m "<msg>"`
- 分支：`git branch -a`、`git switch <b>`
- 跨机器同步：一台 push，另一台 pull。不做文件级拷贝。

## 限制与需确认项
- `push --force`、`reset --hard`、`branch -D`、删远端分支属 L3（黑名单已拦截）。
- `push` 属 L2，先说明推到哪个远端哪个分支。
- 有未提交改动时不做 `pull`、`switch`，先汇报改动。
- 提交信息用主人的语言，不要写"by agent"之类。

## 完成判据
`git status` 干净或符合预期，`git log` 显示新提交或同步后的 HEAD。
