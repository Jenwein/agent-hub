---
name: wsl
description: 管理 Windows 上的 WSL 发行版，并在其中执行命令。
---
# WSL

## 何时使用
主人提到 WSL、Ubuntu（在 Windows 机器上下文里）、或要在 Linux 环境里做事但目标机器是 Windows。

## 输入
资源名（type 为 wsl，如 `desktop/wsl`）。一台机器有多个发行版时各是独立资源，不明确就反问。

## 步骤
1. `bin/hub-check <name>`。WSL 资源在线要求宿主 Windows 在线。
2. 在 WSL 内执行：`bin/hub-run desktop/wsl '<bash 命令>'`。
3. 管理发行版本身（列表、启停、导入导出）在宿主 Windows 上执行 `wsl.exe`。

## 调用
| 目的 | 在哪 | 命令 |
|------|------|------|
| 列发行版 | 宿主 | `wsl.exe -l -v` |
| 停止发行版 | 宿主 | `wsl.exe -t <distro>` |
| 关闭全部 | 宿主 | `wsl.exe --shutdown` |
| 导出备份 | 宿主 | `wsl.exe --export <distro> <path.tar>` |
| 内部执行 | WSL | 任意 bash |
| 访问 Windows 盘 | WSL | `/mnt/c`、`/mnt/d` |

## 限制与需确认项
- `wsl.exe --shutdown` 会终止所有发行版里的进程，属 L2，先说明。
- `--unregister` 会删除发行版全部数据，属 L3。
- WSL 内的 docker 若与 Docker Desktop 集成，和 `desktop/docker` 是同一个引擎，不要重复操作。

## 完成判据
命令成功，查询验证。
