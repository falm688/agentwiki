---
tags: [backtest, dashboard, progress, results, refactor]
status: done
created: 2026-05-30
---

**全量回测系统改造：统一进度条 + 掘金量化风格详细结果展示**

## 改造范围

覆盖所有策略回测：
- **自定义回测**（天时·换手率/深跌企稳/宽基动量）— qteasy 真实回测
- **打板回测**（一进二/弱转强/N字低吸）— 独立回测引擎

## 后端新增

| 文件 | 功能 |
|:----|:-----|
| `routers/backtest_custom.py`（重写） | 异步启动qteasy回测 + 进度查询 + 结果返回 |
| `routers/backtest_short_term.py`（新建） | 异步启动打板回测 + 进度查询 + 结果返回 |
| `strategies/analysis/backtest_runner_v2.py`（新建） | qteasy通用Runner，写进度文件 + 结构化JSON |

## API统一模式

```
POST /api/v1/backtest/custom       → 启动回测（后台）
GET  /api/v1/backtest/custom/status → 进度(%) + 结果
GET  /api/v1/backtest/custom/history → 历史记录

POST /api/v1/backtest/short-term/run    → 启动打板回测
GET  /api/v1/backtest/short-term/status → 进度(%) + 结果
```

## 前端新增/改造

| 页面 | 改进 |
|:----|:-----|
| `CustomBacktest.vue`（重写） | 进度条 + 绩效摘要卡片 + 净值/回撤曲线 + 月度热力图 + 年度收益柱状图 + 交易清单 |
| `ShortTermBacktest.vue`（新建） | 同上 + 三模式对比表 |
| `App.vue` | 侧边栏新增「打板回测」入口 |
| `main.js` | 路由新增 `/backtest-short` |

## 打板回测v3.0结果（60天，优化后旧版数据）

| 模式 | 交易数 | 胜率 | 平均收益 |
|:----|:-----:|:---:|:-------:|
| 一进二 | 104 | 53.8% | +1.87% |
| 弱转强 | 166 | 42.8% | +0.60% |
| N字低吸 | 3857 | 42.0% | +0.05% |

## 待改进
- backtest_short_term_full.py 性能优化（mode3 仍需约5分钟）
- 打板回测结果持久化到MySQL
