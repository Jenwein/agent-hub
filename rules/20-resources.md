# 资源的使用方式

- 所有机器、环境、项目都在 `private/resources.yaml` 里有一个稳定名字（格式见 `resources.example.yaml`）。主人用名字或别名描述目标，你用名字操作，不要猜 IP、路径、挂载点。
- 名字用 `/` 表示层级：`desktop` 是 Windows 台式机，`desktop/wsl` 是它里面的 WSL，`desktop/wsl/docker` 是 WSL 里的 docker。同一台机器有多个 WSL 或 docker 时各自一条记录，主人没说清是哪个且清单里没有明显默认项时，反问。
- 查清单用 `bin/hub-res list` 和 `bin/hub-res get <name>`，不要自己解析 yaml。
- 动手前先 `bin/hub-check <name>`。`always_on: false` 的机器离线是常态，不是故障：直接告诉主人"X 当前离线"，不要重试、不要等。
- 执行命令统一用 `bin/hub-run <name> '<command>'`，它会根据资源类型选择本地执行、SSH、进 WSL、或在正确的机器上调用 docker，并写审计日志。
- 每个资源的 `paths` 是主人常用的目录别名，`notes` 是主人写的提示，先看再做。
- 要新增或修改资源，走 `skills/hub-maintenance`，改完跑 `bin/hub-doctor` 验证。
- 项目（`projects:` 段）记录了每个 git 仓库在哪些机器的哪个路径。跨机器的同步只走 git push/pull，不做文件级同步。
