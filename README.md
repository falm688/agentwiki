---
tags: [meta]
status: active
created: 2026-05-25
---

# Hermes 量化交易知识库

左侧超跌反转（V4）+ 右侧趋势跟随的双策略框架知识库。

## 快速入口

| 你想做什么 | 看这个 |
|:---|:---|
| 了解 V4 策略 | [策略-V4](./strategies/v4-reversal.md) |
| 了解策略在不同市场的表现 | [回测年度分析](./backtests/yearly-breakdown.md) |
| 查看决策记录 | [decisions/INDEX.md](./decisions/INDEX.md) |
| 想写新内容 | [写作规范](./schema/conventions.md) |
| 有新 Agent 接入 | 先读 [INDEX.md](./INDEX.md) + [schema](./schema/conventions.md) |

## 知识架构

```
原始资料层 (raw/)    ← 只读：回测日志、Session记录
     ↓ 编译
知识库层 (/)         ← Agent读写：策略、回测、决策
     ↓ 指导
规范层 (schema/)     ← 规定怎么写
```
