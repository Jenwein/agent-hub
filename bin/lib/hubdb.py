"""被 bin/hub-ledger、hub-memo、hub-task、hub-remind 共用：定位 hub 目录、打开数据库、输出表格。"""
import os, sqlite3, sys, pathlib

HUB_DIR = pathlib.Path(os.environ.get("HUB_DIR") or pathlib.Path(__file__).resolve().parents[2])
STATE_DIR = HUB_DIR / "private" / "state"
DB = STATE_DIR / "hub.db"


def connect():
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    con = sqlite3.connect(DB)
    con.row_factory = sqlite3.Row
    con.executescript((HUB_DIR / "bin" / "schema.sql").read_text(encoding="utf-8"))
    return con


def die(msg, code=1):
    print(f"hub: {msg}", file=sys.stderr)
    sys.exit(code)


def table(rows, cols):
    if not rows:
        print("(空)")
        return
    data = [["" if r[c] is None else str(r[c]) for c in cols] for r in rows]
    w = [max(len(c), *(len(d[i]) for d in data)) for i, c in enumerate(cols)]
    print("  ".join(c.ljust(w[i]) for i, c in enumerate(cols)))
    for d in data:
        print("  ".join(d[i].ljust(w[i]) for i in range(len(cols))))
