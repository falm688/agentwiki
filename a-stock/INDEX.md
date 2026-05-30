---
title: A股量化交易知识库 — 总目录
tags: [index, a-stock, 天时V4, V4超跌]
status: active
last_updated: 2026-06-03
---

# A股量化交易知识库

> 策略开发、回测验证、模拟盘运行的全过程记录

---

## 策略总览

| 策略 | 状态 | 年化 | 回撤 | 说明 |
|:----|:----:|:---:|:---:|:-----|
| **天时V4** 🏆 | ✅ 最优 | **31.3%** | **19.1%** | 气候分类器+V4超跌+ETF轮动 |
| **天时V7** 🆕 | ✅ 实盘就绪 | **20.7%** | **22.7%** | **V6 + TR>2(日换手率>2%)过滤 — 当前最优** |
| **资金流因子** | ❌ 无效 | — | — | 6M行数据全验证，无叠加价值 |
|| **短线打板** | ✅ 活跃 | — | — | 一进二68.9%/弱转强47.8%，详见[回测文档](./短线打板回测.md) |

**详见**：[天时V4-策略文档](./天时V4-策略文档.md)

---

## 目录

### 📐 策略文档
- [天时V4 — 最优策略](./天时V4-策略文档.md) — 完整架构、参数、回测结果
- [天时V7 — V6+TR2实盘就绪](./v6-tr2.md) — 年化+20.7%/回撤-22.7%，资金流因子全验证
- [实盘操作手册](./实盘操作手册.md) — 模拟盘运行指南

### 🔬 回测 & 验证
- [SQL引擎回测结果](./backtests/sql-engine-summary.md) — 最终验证 +470.52%/年化31.3%
- [掘金量化交叉验证-差异诊断](./掘金交叉验证-差异诊断.md) — 掘金与SQL引擎结果差异分析
- [逐年收益分解](./backtests/yearly-breakdown.md) — 各年份详细收益

### 🗂 脚本目录（最新结构）

```text
trading/                             # ~/.hermes/profiles/alex/home/trading/
├── core/                            # 共享核心模块
│   ├── base.py                      # BaseStrategy + Signal
│   ├── backtest_engine.py           # 回测引擎
│   ├── data_loader.py               # 数据加载（MySQL + 前复权）
│   ├── data.py / factors.py         # 旧版兼容
│   ├── simulator_v2.py              # 模拟交易引擎（MySQL版）
│   ├── simulator.py                 # 旧版模拟引擎
│   ├── realtime.py                  # 腾讯实时行情API
│   ├── config.py                    # 统一配置
│   ├── portfolio.py                 # 组合管理
│   ├── risk_control.py              # 风控系统
│   └── audit.py                     # 审计数据包
│
├── strategies/                      # 策略实现
│   ├── tianshi_tr/                  # 天时·换手率
│   ├── tianshi_stab/               # 天时·深跌企稳
│   ├── etf_momentum/               # 宽基动量
│   └── short_term/                  # 短线打板
│
├── tools/                           # 执行脚本
│   ├── daily_execute_1450.py        # 14:50统一入口
│   ├── fast_loader.py               # 快速数据加载+缓存
│   ├── sync_data_1830.py            # 数据补录
│   ├── daily_health_check.py        # 健康检查
│   └── *_daily_signal.py / _wrapper.sh
│
├── scripts/                         # 回测 & 分析
├── tests/                           # 测试
├── output/                          # 模拟盘状态
├── data/backtest/                   # 回测结果CSV
├── active/ / analysis/ / archive/   # 研究/废弃脚本
└── legacy_strategies/               # stock-trading旧策略参考
```

### 📋 决策记录
详见 `archive_decisions_2026-05/`（已归档）

---

## 当前开发进度

- [x] 天时V4 — SQL引擎验证通过 (+470.52%)
- [x] **天时V7 — V6+TR2: 年化+20.7%/回撤-22.7% ✅ 实盘就绪**
- [x] 资金流因子全量验证 — 6M行数据，无叠加价值
- [x] 入场企稳过滤 — 过拟合验证通过
- [x] 气候分类器BUG修复 — 死区修复完成
- [x] 因子数据补全 — daily_basic全字段100%覆盖
- [x] 废弃脚本清理 — active目录46→19个
- [x] 日期格式Bug修复 — daily_basic `20210104` vs stock_daily `2021-01-04` 统一
- [ ] 模拟盘升级 — V6+TR2切换（待用户确认）

---

## 快速导航

| 想做什么 | 看这里 |
|:---------|:-------|
| 了解数据交换协议 | [Agent ↔ Frontend 协议](./agent-frontend-protocol.md) |
| 查策略文件位置 | [策略文件地图](./策略文件地图.md) |
| **系统操作指南** | **[📖 用户手册](./用户手册.md)** ← 必读 |
| 运行回测 | `scripts/compare_annual.py` |
| 修改策略参数 | `strategies/*/config.json` |
| 看掘金对比 | [掘金交叉验证-差异诊断](./掘金交叉验证-差异诊断.md) |
| 查看历史讨论 | `archive_decisions_2026-05/` |
