---
name: docker
description: 查看和管理容器、镜像、compose 项目。
---
# Docker

## 何时使用
主人提到容器、compose、某个跑在 docker 里的服务。

## 输入
docker 资源名（如 `server/docker`、`desktop/docker`），容器或 compose 项目名。

## 步骤
1. `bin/hub-check <name>`。
2. `bin/hub-run <name> '<不带 docker 前缀的子命令>'`，hub-run 会自动补 `docker` 和 `--context`。compose 命令写 `compose -f <path> ...`。
3. 变更后 `ps` 或 `logs` 验证。

## 调用
| 目的 | 命令（hub-run 参数） |
|------|------|
| 列容器 | `ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"` |
| 日志 | `logs --tail 100 <c>` |
| 启停重启 | `start|stop|restart <c>` |
| 进入执行 | `exec <c> <cmd>` |
| 资源占用 | `stats --no-stream` |
| compose | `compose -f <dir>/docker-compose.yml up -d` / `ps` / `logs --tail 100` / `pull` |
| 空间 | `system df` |

## 限制与需确认项
- `volume rm`、`volume prune`、`system prune`、`rm -f` 属 L3（黑名单已拦截）。
- `compose down -v` 会删卷，属 L3。
- 停止对外服务属 L2，先说明。
- 更新镜像前先看 compose 文件确认没有把数据放在匿名卷。

## 完成判据
`ps` 显示预期状态，`logs` 无新的报错。
