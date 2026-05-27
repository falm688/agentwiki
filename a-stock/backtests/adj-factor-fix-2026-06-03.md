---
title: SQL引擎复权问题 — 2026-06-03 诊断
created: 2026-06-03
tags: [天时V4, 前复权, BUG修复, SQL引擎]
---

# SQL引擎复权问题诊断

## 问题

`stock_daily` 表的 `close` 是**不复权**原始收盘价。天时V4回测直接使用 `close` 计算60日跌幅和TP/SL，导致：

- 分红送股导致的价格跳空被误判为涨跌
- 60日跌>8%入场条件可能虚高或虚低
- TP=12%/SL=12%触发可能因除权缺口提前/延后

## 修复

改用 `pct_chg`（涨跌幅%）从最新日期往前递推计算前复权价格：

```python
adj_close[-1] = close[-1]  # 最新日期为基准
for j in range(len-2, -1, -1):
    adj_close[j] = adj_close[j+1] / (1 + pct_chg[j+1] / 100)
```

## 修改文件

`strategies/tools/active/bt_tianshi_final.py` — 数据加载段重写

## 状态

- [x] 脚本修改完成
- [ ] 前复权回测结果待验证
- [ ] 如有效需将其他回测脚本也更新

## 后续

如果前复权回测结果与掘金量化接近，则SQL引擎可信。
如果仍然差距巨大，则SQL引擎有更深层bug，应放弃。
