# 部署

以下按"一台常开 Linux 服务器做主脑，Windows 机器被管理"的形态写。各工具本身的安装和配置以其官方文档为准，这里只列要做什么。

## 1. 服务器（主脑）

```bash
# 依赖
sudo apt update && sudo apt install -y git python3 sqlite3 openssh-client
# yq（mikefarah 版，apt 里的 yq 是另一个实现，语法不同）
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && sudo chmod +x /usr/local/bin/yq
# Node（Codex CLI 需要）
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && sudo apt install -y nodejs
npm install -g @openai/codex cc-connect
# Tailscale
curl -fsSL https://tailscale.com/install.sh | sh && sudo tailscale up
```

```bash
# hub
git clone https://github.com/Jenwein/agent-hub.git ~/hub
git clone <私有仓库> ~/hub/private        # 或 mkdir -p ~/hub/private/{rules,skills,state}
cp ~/hub/resources.example.yaml ~/hub/private/resources.yaml   # 按实际改
~/hub/bin/hub-db-init
~/hub/bin/hub-link-skills
~/hub/bin/hub-doctor
```

内存 2G 以下的机器加 swap：`sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile`，并写进 `/etc/fstab`。

### SSH 到各机器

`~/.ssh/config` 里为每台机器写一个 Host 别名，名字与 `resources.yaml` 的 `ssh_host` 一致：

```
Host desktop
    HostName desktop            # Tailscale MagicDNS 名
    User <windows 用户名>
    IdentityFile ~/.ssh/id_ed25519
```

### Codex 与 cc-connect

- `codex login` 完成登录
- cc-connect 按官方文档配置 Discord bot；project 的 `work_dir` 指向 `~/hub`，agent 选 codex，模式 yolo。用 systemd 用户服务或 `nohup` 常驻。
- Discord 提醒投递：在 Discord 频道建一个 webhook，写到 `private/resources.yaml`：
  ```yaml
  services:
    discord_webhook: https://discord.com/api/webhooks/...
  ```

### cron

```
* * * * *  ~/hub/bin/hub-remind due --notify >> ~/hub/private/state/logs/remind.log 2>&1
0 3 * * *  ~/hub/bin/hub-backup >> ~/hub/private/state/logs/backup.log 2>&1
```

## 2. Windows 机器（被管理）

1. 安装 Tailscale 并登录同一账号。
2. 开启 OpenSSH Server：设置 → 系统 → 可选功能 → 添加"OpenSSH 服务器"，然后以管理员 PowerShell：
   ```powershell
   Set-Service sshd -StartupType Automatic; Start-Service sshd
   New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Program Files\PowerShell\7\pwsh.exe" -PropertyType String -Force
   ```
   没装 PowerShell 7 就用 `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`。
3. 把服务器的公钥追加到 `C:\ProgramData\ssh\administrators_authorized_keys`（管理员账号）或 `~\.ssh\authorized_keys`（普通账号），前者要收紧 ACL，见 OpenSSH for Windows 文档。
4. 在服务器上 `ssh desktop '$PSVersionTable.PSVersion'` 验证。
5. WSL 不需要额外配置；`hub-run desktop/wsl` 会经宿主进入。

## 3. 验证

```bash
~/hub/bin/hub-doctor
~/hub/bin/hub-run desktop 'hostname'
~/hub/bin/hub-run desktop/wsl 'uname -a'
~/hub/bin/hub-ledger add 1 测试 && ~/hub/bin/hub-ledger list && ~/hub/bin/hub-ledger del 1
```

## 4. 日常维护

- 更新：`~/hub/bin/hub-sync`
- 备份在 `~/backups/hub/`，按需再同步到别处
- 新增机器：改 `private/resources.yaml`，`~/.ssh/config` 加 Host，跑 `hub-doctor`
