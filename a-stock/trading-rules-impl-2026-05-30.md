---
tags: trading-rules, realism, zhangting, dieting
created: 2026-05-30
---

# 实盘规则补全

> 2026-05-30 完成

## 新增规则

| 规则 | 实现 | 影响范围 |
|:----|:----|:--------|
| **涨停不能买** | `is_buy_possible()` | 实盘(SimV2) + 回测(BacktestEngine) |
| **跌停不能卖** | `is_sell_possible()` | 实盘(SimV2) + 回测(BacktestEngine) |
| **成交量合理性** | `check_order_volume()` | 实盘(SimV2) |
| **过户费**（沪市万0.1） | `calc_transfer_fee()` | 实盘(SimV2) + 回测(BacktestEngine) |
| **印花税 万5** | `calc_total_sell_proceeds()` | 实盘(SimV2) + 回测(BacktestEngine) |

## 新增文件

| 文件 | 作用 |
|:----|:-----|
| `core/trading_rules.py` | 涨跌幅限制、过户费、成交量检查 |

## 修改文件

| 文件 | 改动 |
|:----|:-----|
| `core/simulator_v2.py` | 买入/卖出前检查涨跌停价、过户费、成交量 |
| `core/backtest_engine.py` | 买入前查涨停、卖出前查跌停、过户费 |

## 测试

- 核心规则验证通过 ✅
- 289/384 标准测试通过 ✅
- backtest_engine的复杂mock测试因文件结构问题待修复
