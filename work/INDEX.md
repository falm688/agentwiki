---
tags: [work, journal, weekly, yearly, mistakes, insights]
status: active
created: 2026-05-26
---

# 工作区总览

**一句话结论：个人工作记录区，包括每日工作流水、周报、年报、错题本和学习收获。**

## 目录结构

| 目录 | 内容 | 更新频率 |
|:---|:---|:---|
| [journal/](./journal/) | 每日工作流水 | 每次对话自动更新 |
| [weekly/](./weekly/) | 周报 | 每周日自动生成 |
| [yearly/](./yearly/) | 年报 | 每年12/31自动生成 |
| [mistakes/](./mistakes/) | 工作中的错误和教训 | 发生时记录 |
| [insights/](./insights/) | 学到的东西、方法论 | 有收获时记录 |
| [projects/](./projects/) | 项目跟踪 | 随项目进度 |
| [system-docs/](./system-docs/) | 系统文档知识库 | 按需更新 |

## 本周状态

- **当前周**: 2026-W22
- **进行中**: 搭建工作记录系统
- **待办**:
  - [ ] 完成工作记录系统搭建
  - [ ] 整理TA系统文档知识库

## 记录方式

1. **自动记录**: 每次对话中涉及的工作内容自动写入 `journal/今日.md`
2. **主动记录**: 你说"记一下"或描述工作内容时立即记录
3. **不记录**: 说"不记"或"私事"时跳过
4. **纠正**: 说"改一下"时修正已有记录

## 与其他 Agent 的边界

| Agent | 负责区域 | 不触碰 |
|:---|:---|:---|
| 工作助手（我） | `work/` | `a-stock/`, `btc/`, `learning/` |
| Alex (Hermes) | `a-stock/` | `work/`, `btc/`, `learning/` |
| BTC Agent | `btc/` | `work/`, `a-stock/`, `learning/` |
| ai-tutor | `learning/` | `work/`, `a-stock/`, `btc/` |

## 相关页面

- [知识库总览](../INDEX.md)
