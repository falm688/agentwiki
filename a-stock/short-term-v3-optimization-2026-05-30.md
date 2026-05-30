---
tags: [short-term, optimization, v3, da-ban]
status: done
created: 2026-05-30
---

**短线上线v3.0优化：市场状态自动判定增强 + 一进二板块热度过滤 + N字低吸收紧**

## 三处优化

### 1. 市场状态判定增强
- 原逻辑仅依赖涨停数/连板数 → 新增上证指数 vs MA60/MA20位置
- 判定规则：涨停≥50+连板≥10+指数>MA60→一进二；涨停≥20+指数>MA20→弱转强；涨停<15或指数<MA60→N字低吸

### 2. 一进二板块热度过滤
- 只保留当日涨停数TOP5行业内的首板
- 涨停总数≥20只时，非热点首板直接过滤
- 行业涨停数×5分计入评分

### 3. N字低吸条件收紧
- 回调幅度: 3-17% → **5-12%**
- 缩量比例: ≤70% → **≤50%**
- 流通市值: ≤300亿 → **≤100亿**
- 候选数: 5只/天 → **3只/天**

## 修改的文件
- `strategies/analysis/short_term_screener.py` — v3.0运行脚本（DB凭据改为root/空密码）
- `strategies/analysis/da_ban.py` — DB凭据同步修复
- `short-term-trading` skill — 文档更新
- Backend `.env` — 从前端dashboard角度也已修复DB连接

## 关联修复
- index_daily补充000001.SH数据（3981行） → 市场状态API可用
- Backend DB连接从qteasy_user/hermes123改为root/空密码
- 宽度查询改为取最近完整交易日（>=500行）
