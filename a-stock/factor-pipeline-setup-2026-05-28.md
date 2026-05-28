---
date: 2026-05-28
author: Alex (量化Agent)
tags: [因子工程, 资金流, 融资融券, Tushare, 数据管线]
---

# 因子数据管线搭建（2026-05-28）

## 背景
目标：从Tushare已有数据中挖掘量化因子，提升V4策略表现。
放弃部署社区MCP（数据深度不足），转向深度挖掘Tushare 258个工具的潜力。

## 已完成

### 1. 资金流因子管线
- **脚本**: `tools/update_factors.py`
- **数据源**: Tushare `moneyflow` API
- **MySQL表**: `moneyflow_factors`
- **覆盖时间**: 2021-01-04 ~ 2026-05-28（补了74个交易日缺口）
- **数据量**: 7,137,873 行
- **因子清单**（7个）:
  1. `net_flow_ratio` – 净流入比率(%)
  2. `big_buy_ratio` – 大单买入占比(%)
  3. `net_big_money` – 大单净额(万元)
  4. `net_small` – 小单净额(万元)
  5. `big_act_ratio` – 大单活跃度(%)
  6. `net_big_ratio` – 净大单占比(%)
  7. `main_buy_ratio` – 主买比率(%)
- **自动更新**: cron `update-moneyflow-factors` 交易日20:00

### 2. 融资融券因子管线
- **脚本**: `tools/update_margin_factors.py`
- **数据源**: Tushare `margin_detail` API
- **MySQL表**: `margin_factors`
- **因子清单**（4个）:
  1. `margin_change_ratio` – 融资余额变化率(%) → 杠杆情绪
  2. `margin_buy_sell_ratio` – 融资买入/偿还比 → 买入意愿
  3. `short_ratio` – 融券占比(%) → 做空强度
  4. `net_margin_flow` – 净融资流入(万元)
- **自动更新**: cron `update-margin-factors` 交易日20:30
- **状态**: 全量历史数据后台拉取中（约50万行）

### 3. 每日更新时序
| 时间 | 任务 | 说明 |
|:----|:-----|:-----|
| 18:30 | 三策略信号生成 | 已有cron |
| 20:00 | 资金流因子更新 | 新设 |
| 20:30 | 融资融券因子更新 | 新设 |

## MCP调研结论（附）
调研了ModelScope MCP广场、GitHub多个A股MCP：
- 社区MCP数据深度远不如Tushare（无筹码分布/龙虎榜/资金流向/板块概念等）
- FinQ4Cn-mcp-server（最新）有回测引擎+Python REPL+新闻，可作为补充
- 其他（a-share-mcp、mcp-cn-a-stock等）与Tushare能力重叠且不及
- **结论**: 不部署额外MCP，专注Tushare已有数据挖掘

## 待办
1. 等待融资融券全量数据拉完
2. 北向资金因子（moneyflow_hsgt）
3. 因子有效性回测：将资金流/融资融券因子作为V4策略的额外过滤条件
4. 如有必要：龙虎榜因子（top_list）

## 技术备忘
- MySQL密码: `hermes123`（不是qteasy123）
- Tushare SDK (1.4.29) 可以直接通过Python调用，比MCP工具更高效
- 注意: `get_db()` 用 `**DB_CONFIG` unpack dict，pyright会报类型错但运行正常
