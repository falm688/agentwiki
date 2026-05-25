---
tags: [btc, strategies, 索引]
status: active
created: 2026-05-25
updated: 2026-05-25
---

# BTC 策略文档

**BTC 领域所有交易策略的文档。**

## 策略列表

| 策略 | 类型 | 状态 | 文档 |
|:---|:---|:---|:---|
| AdaptiveMomentum | 自适应动量 | 模拟盘运行中 | [adaptive-momentum.md](adaptive-momentum.md) |

## 策略对比

| 维度 | AdaptiveMomentum |
|:---|:---|
| 时间框架 | 4h（主）+ 1h/1d（辅助） |
| 市场模式 | 趋势跟踪（ADX>25）/ 均值回归（ADX<25） |
| 入场条件 | 趋势：价格>EMA10>EMA30>EMA100 + RSI 50-80 |
| 止损 | 2×ATR |
| 盈亏比 | 1:2 |
| 风控 | 动态仓位 + 组合风险上限 |
