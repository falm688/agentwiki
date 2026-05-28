---
tags: [复盘, 踩坑, 模拟盘, 自动化]
status: current
created: 2026-05-28
---

# 模拟盘搭建复盘 — 踩坑记录

> **一句话结论：** 2026-05-28 全面清理旧模拟盘数据，新建三个独立模拟盘（天时·换手率/天时·深跌企稳/宽基动量），过程中踩了6个坑，全部修复并归档。

## 背景

原有模拟盘夹缠不清：V3（雨风 ETF轮动）和 V4（个股超跌反转）的状态文件混在一起，`trading_sim.json` 是 V3 的但 V4 也读它，导致数据混淆。加上旧 cron 全部暂停，状态混乱。

## 新建的三个模拟盘

| 策略名 | 核心逻辑 | 参数 | 回测绩效 |
|:------|:--------|:----|:--------|
| **天时·换手率** | ED=15% + TR>2 换手率过滤 | TP=16%, SL=12%, HD=25, MAX=3, SLLP=1% | 待回测 |
| **天时·深跌企稳** | ED=15% + ret5>-5% + 冷却30天 | 同上 + 冷却期 | 待回测 |
| **宽基动量** | 4指数20日动量+>MA60, 5%换仓阈值 | ETF费率万1.7 | 待回测 |

## 踩坑记录（按时间顺序）

### 坑1：读取了错误的模拟盘状态文件

**现象：** 报告持仓时用了 `strategies/scripts/trading_sim.json`，里面是 V3（雨风）的数据（ETF 159915，日期 2026-05-26）

**原因：** 我默认以为最明显的 JSON 就是模拟盘状态文件，但 V4 其实用的是 MySQL `sim_state/sim_holdings/sim_trades` 表

**教训：** 先确认策略架构，V4/V6/V7 系用的是 MySQL，V3 系用的 JSON。查模拟盘状态先查 MySQL。

**修复：** 旧 `trading_sim.json` 已移入 `strategies/archive/scripts/`

---

### 坑2：V4 模拟盘 trade 日期标错

**现象：** MySQL `sim_trades` 表里 trade_date=2026-05-26，但 `sim_holdings` 的 buy_date=2026-05-27

**原因：** `v4_sim.py` 手动运行时传了 `today='2026-05-26'`，但初始化时 `start_date` 是 2026-05-27。两个日期不一致。

**教训：** 仿盘建仓的日期必须统一。所有日期从 `trade_dates[-1]`（数据库最新交易日）获取，不要硬编码。

**修复：** 新脚本 `tianshi_tr/stab_daily_signal.py` 都用 `dl.trade_dates[-1]` 获取最新日期。

---

### 坑3：trading_sim.py 在 archive/ 目录无法导入

**现象：** v4-daily-close cron 报错 `ModuleNotFoundError: No module named 'trading_sim'`

**原因：** `v4_sim.py` import `from trading_sim import ...`，但 `trading_sim.py` 在 `strategies/tools/archive/` 不在 `active/`。

**教训：** 使用中的模块不能放 archive。archive 只能放不再使用的历史代码。

**修复：** 新模拟盘直接用 `core.simulator.Simulator` 引擎，不再依赖旧 `trading_sim.py`。

---

### 坑4：cron deliver=local 导致飞书无推送

**现象：** v4-daily-close cron 在 27日 18:30 跑了但没任何通知

**原因：** cron job 的 `deliver: "local"` 只存本地不推送

**教训：** 新建 cron 时默认 `deliver: "origin"`，除非明确需要静默运行

**修复：** 三个新 cron 都已设 `deliver: "origin"` → 会推送到飞书

---

### 坑7：cron script 路径解析错误

**现象：** `etf-momentum-daily-close` 报错 `Script not found: /Users/falm/.hermes/profiles/alex/scripts/strategies/tools/...`

**原因：** cron 的 `script` 参数是相对 `~/.hermes/profiles/<profile>/scripts/` 目录的路径。放绝对路径不行，必须把脚本放进该目录后只用文件名。

**教训：** 脚本放 `~/.hermes/profiles/<profile>/scripts/`，cron 里 `script` 只写文件名（如 `tianshi_tr_daily.sh`），不要路径。

**修复：** 已把三个 wrapper 脚本复制到 `~/.hermes/profiles/alex/scripts/`，cron 全部重建为仅文件名引用。

---

### 坑5：DataLoader 加载 4000 只股票耗时 2+ 分钟

**现象：** 手动测试 `tianshi_stab_daily_signal.py` 超时（120s）

**原因：** `DataLoader.load_adj_prices()` 从 MySQL 逐批加载所有股票历史并计算前复权

**教训：** 手动测试时给足够 timeout（600s）；cron 运行不受限没问题

**修复：** 无代码修复。后台任务用 `notify_on_complete` 等待即可。

---

### 坑6：当天下午的优化讨论上下文丢失

**现象：** 用户说"今天下午优化了很多版"，但我无法回忆起具体参数

**原因：** Hermes 会话上下文有限，长对话会导致早期内容被截断

**教训：** 重要结论（策略参数、回测结果）必须立即写入知识库 wiki，不能只存在对话里

**修复：** 本文件即是修复措施。每次重要决策后立即写 wiki。

## 三策略回测验证（2021-2026）

| 策略 | 年化 | 总收益 | 回撤 | 交易 | 对比HS300 |
|:----|:---:|:-----:|:---:|:---:|:--------:|
| 🥇 **天时·深跌企稳** | **+21.4%** | **+173.5%** | -28.8% | 201笔 | +176.7pp |
| 🥈 **天时·换手率** (V6+TR2) | **+20.7%** | **+105.2%** | -22.7% | 240笔 | +108.5pp |
| 🥉 **宽基动量** | **+12.2%** | **+81.9%** | -0.2% | 37笔 | +84.2pp |
| HS300基准 | -2.3% | -11.3% | -33% | — | — |

> 数据来源：2026-05-28 日间优化跑出的最终对比表

### 坑8：宽基动量用了指数点位而非ETF价格

**现象：** 脚本显示"买入"但状态文件始终0持仓。买入价用了指数点位（创业板指4125点）而非ETF实际价格（~¥2-4），`shares = 0`。

**原因：** ETF数据不在`stock_daily`表里（仅个股），查不到ETF收盘价。

**教训：** ETF动量轮动不需要ETF绝对价格，用指数百分比变化计算净值更可靠。

**修复：** 全量重写`etf_momentum_daily_signal.py`，按`nav = 初始资金 × (1+涨幅)`用指数百分比推算净值，换仓时计提¥20费用。

---

### 坑9：DataLoader加载太慢导致cron超时

**现象：** cron 运行`tianshi_tr_daily_signal.py`超时120s失败。DataLoader逐批加载4000只股票并计算前复权，耗时2-3分钟。

**原因：** `core.data.DataLoader` 用 `pd.read_sql` 逐批（500只/批）加载，Python循环计算前复权，IO+CPU都慢。

**修复：**
1. 创建`tools/fast_loader.py` — 单SQL+USE INDEX加载全部数据，向量化groupby计算前复权
2. 首次运行~150s（全量加载+计算），之后缓存到`.adj_cache.pkl`，后续加载仅1秒
3. 天时·换手率/深跌企稳脚本换用`fast_loader.load_fast()`替代DataLoader
4. 仅加载2020年起数据（440万行/3011只/1548天），足够覆盖5年回测

**副作用发现：** `turnover_rate`不在`stock_daily`表而在`daily_basic`表，`fast_loader.get_turnover_rate()`已修正查表来源。

## 自动化的要点

1. **数据源**：MySQL `stock_daily` 表，每晚 13:00 由 `sync-market-data` cron 更新
2. **信号生成**：14:50（尾盘实时价）和 18:30（收盘价）各跑一轮
3. **执行**：脚本自动判断买卖，`Simulator` 引擎执行交易并记录状态
4. **推送**：结果通过飞书 webhook 推送（deliver: origin 或代码内 push_feishu）
5. **日期**：统一用 `dl.trade_dates[-1]` 最新交易日，不硬编码
