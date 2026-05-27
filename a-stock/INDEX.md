---
tags: [index, a-stock]
status: active
created: 2026-06-02
---

# A股量化交易知识库 — 目录

> 本目录记录A股量化策略开发、回测、决策的全过程。

## 策略框架

- **[天时V4 — 最优策略 +259%/年化34%](./天时V4-策略文档.md)** 🏆 — V3.1分类器+企稳过滤+ETF轮动
- [右侧趋势策略（驭风V5）](./strategies/right-side-strategy.md) — V4+气候分类器+ETF轮动
- [气候分类器V2 — bug修复](./climate-classifier-v2-bugfix.md) — 死区修复，V1→V2重写

## 回测

- [SQL引擎验证结果](./backtest/sql-engine-results.md) — 2026-05-28
- [参数扫描](./backtest/param-sweep.md) — ED/TP/SL三维扫描
- [过拟合检查](./backtest/overfitting-check.md)
- [V2分类器+hysteresis参数扫描](./backtests/v2-climate-sweep-2026-06-03.md) — 2026-06-03

## 数据

- [MySQL数据结构](./data/mysql-schema.md)
- [tushare数据更新](./data/tushare-update.md)

## 实盘

- [模拟盘系统](./simulation/sim-trading.md)
- [V4模拟盘运行记录](./simulation/v4-sim-log.md)

## 决策记录

- [策略方向变更](./decisions/strategy-direction-change.md) — 从qteasy到SQL引擎
- [参数扫描结论](./decisions/param-scan-conclusions.md) — ED无效/SL=12%最优
