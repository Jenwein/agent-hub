# shellcheck shell=bash
# 被 bin/ 下所有脚本 source。提供资源清单查询与执行原语。
set -euo pipefail

HUB_DIR="${HUB_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
PRIV_DIR="$HUB_DIR/private"
STATE_DIR="$PRIV_DIR/state"
if [[ -n "${HUB_RESOURCES:-}" ]]; then RES_FILE="$HUB_RESOURCES"
elif [[ -f "$PRIV_DIR/resources.yaml" ]]; then RES_FILE="$PRIV_DIR/resources.yaml"
else RES_FILE="$HUB_DIR/resources.example.yaml"; echo "hub: 未找到 private/resources.yaml，正在使用示例清单" >&2; fi
SSH_OPTS=(-o BatchMode=yes -o ConnectTimeout="${HUB_SSH_TIMEOUT:-6}" -o StrictHostKeyChecking=accept-new)

die() { echo "hub: $*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || die "缺少依赖 $1，见 docs/setup.md"; }
need yq

res_exists() { yq -e ".resources[\"$1\"]" "$RES_FILE" >/dev/null 2>&1; }
res_field()  { yq -r ".resources[\"$1\"].$2 // \"\"" "$RES_FILE"; }
res_list()   { yq -r '.resources | keys | .[]' "$RES_FILE"; }

# 把口头别名解析成资源名
res_resolve() {
  local q="$1"
  if res_exists "$q"; then echo "$q"; return; fi
  local hit
  hit=$(yq -r ".resources | to_entries[] | select(.value.aliases // [] | map(. == \"$q\") | any) | .key" "$RES_FILE" | head -1)
  [[ -n "$hit" ]] && { echo "$hit"; return; }
  die "未知资源 '$q'。可用：$(res_list | tr '\n' ' ')"
}

# always_on：自己没写就沿 via 链继承父资源的值；都没写按 true
res_always_on() {
  local r="$1" v
  while [[ -n "$r" ]]; do
    v=$(yq -r ".resources[\"$r\"].always_on" "$RES_FILE")
    [[ "$v" != "null" ]] && { echo "$v"; return; }
    r=$(res_field "$r" via)
  done
  echo true
}

# 在 Windows 资源上执行 PowerShell：用 EncodedCommand 绕开引号地狱
run_windows() { # host cmd
  local enc; enc=$(printf '%s' "$2" | iconv -f utf-8 -t utf-16le | base64 -w0)
  ssh "${SSH_OPTS[@]}" "$1" -- powershell -NoProfile -NonInteractive -EncodedCommand "$enc"
}

run_linux_ssh() { # host cmd
  ssh "${SSH_OPTS[@]}" "$1" -- bash -lc "$(printf '%q' "$2")"
}

# 核心：在资源 $1 上执行命令 $2
hub_exec() {
  local res="$1" cmd="$2"
  local type reach
  type=$(res_field "$res" type); reach=$(res_field "$res" reach)
  case "$type" in
    linux|windows)
      if [[ "$reach" == "local" ]]; then bash -lc "$cmd"; return; fi
      local host; host=$(res_field "$res" ssh_host); [[ -n "$host" ]] || die "$res 缺少 ssh_host"
      if [[ "$type" == "windows" ]]; then run_windows "$host" "$cmd"; else run_linux_ssh "$host" "$cmd"; fi ;;
    wsl)
      local via distro b64
      via=$(res_field "$res" via); distro=$(res_field "$res" distro)
      [[ -n "$via" && -n "$distro" ]] || die "$res 需要 via 和 distro"
      b64=$(printf '%s' "$cmd" | base64 -w0)
      hub_exec "$via" "wsl.exe -d $distro -- bash -lc \"echo $b64 | base64 -d | bash -l\"" ;;
    docker)
      local via ctx
      via=$(res_field "$res" via); ctx=$(res_field "$res" context)
      [[ -n "$via" ]] || die "$res 需要 via"
      hub_exec "$via" "docker ${ctx:+--context $ctx }$cmd" ;;
    nfs) die "$res 是挂载型资源，请在挂载它的机器上操作，见 mounts 字段" ;;
    *) die "$res 类型 '$type' 未知" ;;
  esac
}
