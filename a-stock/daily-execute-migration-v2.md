---
tags: daily-execute-migration, v2, live-trading
created: 2026-05-30
---

# 14:50实盘执行迁移V2 — 使用策略类选股

> 2026-05-30 迁移完成

## 问题

旧 `daily_execute_1450.py` 硬编码了 CONFIGS 字典做选股条件，与回测框架的 `BaseStrategy.generate_signals()` 是**两套代码**。改参数要改两处，容易出偏差。

## 迁移内容

修改 `tools/daily_execute_1450.py`：

| 旧 | 新 |
|:--|:---|
| `CONFIGS` 字典硬编码 | 动态导入 `strategies/strategies/*/strategy.py` 的策略类 |
| `for _, r in yesterday_df.iterrows():` 手写过滤 | `strategy.generate_signals(date, data)` 统一选股 |
| 手动计算指数动量 | `EtfMomentumStrategy.calculate_indicators()` + `get_momentum_rank()` |

## 不变的部分（保留旧代码）

- SimV2 状态管理（MySQL `sim_state_v2`/`sim_positions_v2` 读写）
- `get_realtime_prices()` 实时行情查询
- 冷却期（cooldown）管理
- 日内实时涨幅过滤（`MAX_INTRADAY`）
- 飞书推送 `push_feishu()`
- Cron 调度脚本（shell wrapper 不变）

## 验证

- ✅ 384测试全通过
- ✅ 3个策略类均可正常导入
- ✅ Syntax OK
- ✅ 回测和实盘现在使用同一套 `generate_signals()`

## 今后改策略

只需修改 `strategies/strategies/<策略名>/config.json` 或 `strategy.py`，
`daily_execute_1450.py` 自动继承修改。
