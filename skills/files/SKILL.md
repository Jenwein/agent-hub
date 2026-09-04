---
name: files
description: 跨机器找文件、看目录、搬运文件、查看和释放空间。
---
# 文件

## 何时使用
主人要找某个文件、看某个目录、把文件从一台机器搬到另一台、清理空间。

## 输入
资源名和路径（或 `paths` 里的别名，如"台式机的下载目录"）。

## 步骤
1. 路径别名从 `bin/hub-res get <name>` 的 `paths` 取。
2. 找：Linux 用 `find <dir> -iname '*x*' -mtime -7`，Windows 用 `Get-ChildItem <dir> -Recurse -Filter *x* | Select FullName,Length,LastWriteTime`。
3. 搬：两台机器之间用服务器中转 `scp`；服务器与机器之间直接 `scp -r <host>:<path> <dest>`。大量文件用 `rsync -avz`（Windows 侧没有 rsync，用 scp）。
4. 删：一律 `bin/hub-safe-rm <name> <path>`，不直接 rm。
5. 空间：见 `windows`、`linux-server` 技能的磁盘命令。

## 调用
- `bin/hub-run`、`bin/hub-safe-rm`
- `scp`、`rsync`：在服务器本地直接执行，host 用 `~/.ssh/config` 里的别名

## 限制与需确认项
- 覆盖已有文件先确认（L2）。
- 清空回收目录 `~/.hub-trash` 属 L3。
- 超过 1G 的传输先估时间并说明。

## 完成判据
目标位置 `ls` / `Get-ChildItem` 能看到文件且大小一致。
