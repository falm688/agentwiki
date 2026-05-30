---
title: Agent ↔ Frontend 数据交换协议
tags: [protocol, architecture, frontend, agent]
status: active
created: 2026-05-30
---

# Agent ↔ Frontend 数据交换协议

> **一句话**：Agent 负责策略研发和回测产出，Frontend 只负责读取展示 —— 通过共享存储的标准化 Schema 解耦，不互相调用 API。

## 架构总览

```
┌─────────────┐  🔵 DM指令      ┌──────────────┐  ✏️ 写结果    ┌────────────┐
│  用户        │◄──────────────►│  Alex Agent  │────────────►│  共享存储   │
│  (指挥者)    │  🟢 DM汇报      │  (策略研发)   │             │ (MySQL/文件)│
└─────────────┘                 └──────────────┘             └──────┬─────┘
       ▲                                                           │
       │              ┌───────────────────┐                        │
       └──────────────│  Frontend Dashboard│◄───────────────────────┘
            👀 看数据  │  (可视化层，只读)   │    📖 HTTP GET
                      └───────────────────┘
```

### 角色分工

| 角色 | 职责 | 能做什么 | 不能做什么 |
|:----|:-----|:--------|:----------|
| **用户** | 指挥策略研发、查看数据 | 通过DM下指令、浏览器看Dashboard | 不直接操作数据库 |
| **Alex Agent** | 策略研发、回测执行、分析 | 写结果到共享存储、回复用户分析 | 不调用Frontend API、不修改Frontend代码 |
| **Frontend** | 数据可视化、展示 | 从共享存储读数据、渲染图表 | 不写策略数据、不触发回测 |

## 协议 A：存储规范

### A1. 数据根目录

```
~/quant-dashboard/data/
├── backtest/
│   ├── short-term/          # 短线打板回测结果
│   │   └── result.json
│   └── tianshi/             # 天时策略回测结果
│       ├── nav.csv
│       └── trades.csv
├── morning-brief/           # 每日投资早报
│   └── {YYYY-MM-DD}.json
├── da-ban/                  # 短线候选股
│   └── candidates.json
├── market-review/           # 收盘复盘
│   └── {YYYY-MM-DD}.json
└── analysis/                # 深度分析
    └── {topic}-{timestamp}.json
```

> ⚠️ `schema_version: "1.0"`  — 任何 Schema 变更必须递增版本号。Frontend 根据版本号选择渲染方式。

### A2. JSON 结果通用 Schema

所有结果文件统一包含以下元字段：

```json
{
  "schema_version": "1.0",
  "generated_by": "alex-agent",
  "generated_at": "2026-05-30 09:00:00",
  "meta": {
    "strategy": "短线打板",
    "period": ["2026-03-03", "2026-05-29"],
    "params": { "stop_loss": 0.05, "position_pct": 0.1 }
  }
}
```

#### A2a. 短线打板结果 Schema (backtest/short-term/result.json)

```json
{
  "schema_version": "1.0",
  "generated_by": "alex-agent",
  "generated_at": "2026-05-30 09:00:00",
  "meta": {
    "strategy": "短线打板回测",
    "period": ["2026-03-03", "2026-05-29"],
    "params": { "stop_loss_pct": 5, "position_pct": 10, "sell_strategy": "D2收盘卖" }
  },
  "summary": {
    "total_trades": 206,
    "total_wins": 108,
    "avg_profit_pct": 1.65,
    "total_return_pct": 33.97,
    "max_drawdown_pct": -8.5
  },
  "modes": {
    "一进二": { "trades_count": 45, "win_rate": 68.9, "avg_profit": 3.48, "trades": [...] },
    "弱转强": { "trades_count": 161, "win_rate": 47.8, "avg_profit": 1.14, "trades": [...] }
  }
}
```

#### A2b. 单个交易记录 Schema

```json
{
  "code": "600000.SH",
  "name": "浦发银行",
  "mode": "一进二",
  "buy_date": "2026-04-02",
  "sell_date": "2026-04-04",
  "buy_price": 13.40,
  "sell_price": 14.48,
  "profit_pct": 8.06,
  "hold_days": 2,
  "open_pct": 4.9,
  "volume_ratio": 7.0,
  "bid_ratio": 5.0,
  "industry": "银行",
  "industry_zts": 3,
  "won": true
}
```

#### A2c. 投资早报 Schema (morning-brief/{date}.json)

```json
{
  "schema_version": "1.0",
  "generated_by": "alex-agent",
  "generated_at": "2026-05-30 09:00:00",
  "date": "2026-05-30",
  "market": {
    "sh_index_pct": 0.32,
    "sz_index_pct": -0.15,
    "total_volume_yi": 8500,
    "up_count": 2100,
    "down_count": 1800
  },
  "hot_sectors": [
    { "name": "人形机器人", "pct_change": 3.2, "net_amount": 12.5, "lead_stock": "..." }
  ],
  "positions": [
    { "code": "002328.SZ", "name": "新朋股份", "cost": 10.366, "shares": 13400, "profit_pct": -3.2 }
  ],
  "short_term_candidates": [
    { "code": "...", "name": "...", "mode": "一进二", "open_pct": 5.2, "volume_ratio": 6.5 }
  ]
}
```

## 协议 B：数据流规范

### B1. 写入方：Alex Agent

```
用户DM: "跑一下短线回测"
              │
              ▼
Agent执行回测脚本 ───→ 写入 ~/quant-dashboard/data/backtest/short-term/result.json
              │                   ├── schema_version: "1.0"
              │                   └── generated_at: 当前时间
              │
              ▼
Agent回复用户: "回测完成：一进二68.9%/3.48%，弱转强47.8%/1.14%"
```

### B2. 读取方：Frontend Dashboard

```
用户打开浏览器 → Frontend → GET /api/v1/backtest/short-term
                               │
                               ▼
                         读文件 ~/quant-dashboard/data/backtest/short-term/result.json
                               │
                               ▼
                         渲染 NAV 曲线、盈亏表格、月度热力图
```

### B3. 禁止事项

- ❌ Agent 不调用 Frontend API
- ❌ Frontend 不调用 Agent
- ❌ Frontend 不写任何策略数据
- ❌ Agent 不修改 Frontend 代码

## 协议 C：Refresh/Staleness 规则

| 场景 | 行为 |
|:----|:-----|
| Frontend 加载页面 | 显示 `generated_at` 时间戳 |
| 数据超过24小时 | 显示⚠️ "数据上次更新于 X，建议联系Alex重跑" |
| Agent 刚写完新结果 | Frontend 下次刷新自动展示最新数据 |
| 用户要求重跑 | Agent 跑完→写文件→通知用户→用户F5刷新 |

## 协议 D：版本演进

| 版本 | 日期 | 变更 |
|:---|:----|:----|
| 1.0 | 2026-05-30 | 初始协议，支持短线打板回测 + 投资早报 |
