---
tags: [btc, 索引]
status: active
created: 2026-05-25
updated: 2026-05-25
---

# BTC 策略库

**BTC/USDT 量化交易策略知识库。专注币安现货/合约交易。**

## 目录结构

| 目录 | 内容 |
|:---|:---|
| `strategies/` | 策略逻辑文档 |
| `backtests/` | 回测结果与分析 |
| `decisions/` | 关键决策记录 |
| `data/` | 行情数据、指标记录 |
| `raw/` | 原始回测日志（只读） |

## 当前策略

- [自适应多时间框架动量策略](strategies/adaptive-momentum.md) — 根据 ADX 切换趋势/回归模式

## 回测结果

- [回测汇总](backtests/summary.md) — 各币种各时间框架表现

## 决策记录

- [decisions/INDEX.md](decisions/INDEX.md) — 按时间排列

## 模拟盘状态

- 初始资金: 100,000 USDT
- 监控币种: BTC/USDT, ETH/USDT
- 运行状态: [观察期](decisions/2026-05-25-paper-trading-start.md)
