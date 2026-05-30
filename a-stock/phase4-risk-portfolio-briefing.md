---
name: phase4-summary
created: 2026-05-30
tags: phase4, risk-control, portfolio, morning-briefing
---

# Phase 4 — 风控系统 + 组合总览 + 早报增强

> 2026-05-30 完成

## 交付物

| 模块 | 文件 | 功能 |
|:----|:----|:------|
| 🔒 风控系统 | `core/risk_control.py` | 4道风控规则 + JSON持久化 |
| 📊 组合总览 | `core/portfolio.py` | 多策略聚合 + 净值对比 |
| 📰 早报增强 | 更新Cron Job (#3d458ee7c7a7) | 新增组合总览+风控模块 |

## 风控系统 (RiskController)

**4道风控规则**：

| 规则 | 阈值 | 动作 |
|:----|:----|:-----|
| ① 策略回撤熔断 | 回撤 > 20% | 暂停买入 + 冷却5天 |
| ② 连续亏损预警 | 连续5笔亏损 | 暂停买入 |
| ③ 单股集中度 | 单股 > 20%总资金 | 告警（不熔断） |
| ④ 组合总回撤 | 组合 > 15% | 全暂停 |

**持久化**：风控状态存 `output/risk_control_state.json`，包含 peak_nav / consecutive_losses / cooldown_until。

## 组合总览 (PortfolioOverview)

- 按策略聚合：总现金、总持仓市值、总资产、累计收益
- 净值历史：加权组合日频净值
- 组合最大回撤、沪深300对比
- 数据源：MySQL `sim_state_v2` / `sim_positions_v2` / `sim_nav_v2` / `sim_trades_v2`

## 早报更新

现有的 📰 投资早报 Cron (09:00 工作日) 已更新 Prompt，新增：

- **策略持仓模块**：查询所有策略的 MySQL 状态 + 持仓明细
- **组合总览**：总资产、总收益、总持仓数
- **风控状态**：读取 `risk_control_state.json`，标记各策略风控等级
- **数据陷阱**：全部已知踩坑已写入Prompt

## 测试

| 文件 | 数量 | 通过 |
|:----|:---:|:----:|
| `tests/test_risk_control.py` | 26 | ✅ |
| `tests/test_portfolio.py` | 17 | ✅ |
| **全量** | **384** | ✅ |
