---
name: linux-server
description: Linux 服务器运维：服务状态、日志、磁盘、内存、cron、软件包。
---
# Linux 服务器

## 何时使用
主人要查看或操作服务器（或任何 type 为 linux 的资源）的系统层面事务。

## 输入
资源名，要做的事。

## 步骤
1. `bin/hub-check <name>`。
2. 用下表命令通过 `bin/hub-run` 执行。服务器本身就是 hub 所在机器时，`hub-run server` 等价于本地执行，但仍然走它以留审计日志。
3. 修改后用查询命令验证。

## 调用
| 目的 | 命令 |
|------|------|
| 概况 | `uptime; free -h; df -h /` |
| 服务 | `systemctl status <u> --no-pager` / `sudo systemctl restart <u>` |
| 日志 | `journalctl -u <u> -n 100 --no-pager` / `journalctl -p err -S today --no-pager` |
| 进程 Top | `ps aux --sort=-%mem \| head -15` |
| 端口 | `ss -tlnp` |
| 包 | `apt list --upgradable` / `sudo apt install -y <pkg>` |
| cron | `crontab -l` |
| 大文件 | `du -xh --max-depth=2 / 2>/dev/null \| sort -rh \| head -20` |

## 限制与需确认项
- 内存小的服务器不要在上面编译大项目或跑占内存的服务；先看 `free -h` 和资源 notes。
- `systemctl disable|mask`、防火墙、sshd、sudoers 修改属 L3（黑名单已拦截）。
- `apt upgrade` 全量升级属 L2，先说明。
- 重启服务器属 L3；重启 cc-connect 自身会中断当前会话，先告知主人。

## 完成判据
查询类给结果；修改类验证状态。
