-- private/state/hub.db 的结构。所有个人事务数据都在这里，通过 bin/hub-* 脚本读写。
PRAGMA journal_mode = WAL;

CREATE TABLE IF NOT EXISTS ledger (
  id         INTEGER PRIMARY KEY,
  date       TEXT NOT NULL,            -- YYYY-MM-DD
  amount     REAL NOT NULL,            -- 支出为正，收入为负
  category   TEXT NOT NULL,
  note       TEXT DEFAULT '',
  created_at TEXT NOT NULL DEFAULT (datetime('now','localtime'))
);
CREATE INDEX IF NOT EXISTS ledger_date ON ledger(date);

CREATE TABLE IF NOT EXISTS memo (
  id         INTEGER PRIMARY KEY,
  text       TEXT NOT NULL,
  tags       TEXT DEFAULT '',          -- 逗号分隔
  archived   INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT (datetime('now','localtime'))
);

CREATE TABLE IF NOT EXISTS task (
  id         INTEGER PRIMARY KEY,
  title      TEXT NOT NULL,
  status     TEXT NOT NULL DEFAULT 'todo',   -- todo | doing | waiting | done
  notes      TEXT DEFAULT '',                -- 进度、上下文，agent 跨会话接续用
  created_at TEXT NOT NULL DEFAULT (datetime('now','localtime')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now','localtime'))
);

CREATE TABLE IF NOT EXISTS reminder (
  id         INTEGER PRIMARY KEY,
  due_at     TEXT NOT NULL,            -- YYYY-MM-DD HH:MM
  text       TEXT NOT NULL,
  fired_at   TEXT,                     -- 已触发时间，NULL 表示未触发
  created_at TEXT NOT NULL DEFAULT (datetime('now','localtime'))
);
CREATE INDEX IF NOT EXISTS reminder_due ON reminder(due_at) WHERE fired_at IS NULL;
