---
tags: [meta, conventions]
status: active
---

# 知识库写作规范

所有 Agent 写入本知识库时遵循以下规范。

## 文件结构

```
目录/
├── INDEX.md    ← 必须：告诉读者这个目录有什么
├── topic.md    ← 内容页面
└── subtopic/   ← 子目录
    └── INDEX.md
```

## 每个页面的结构

```markdown
---
tags: [标签1, 标签2]
status: active | deprecated | draft
created: YYYY-MM-DD
---

# 标题

**一句话结论：这句话是全文核心，Agent扫一眼就够。**

## 完整分析
（正文）

## 关键数据
| 指标 | 数值 |

## 相关页面
- [链接](./path/to/page.md)
```

## 规则

1. **一句话结论必须置顶** — Agent 通过这个决定是否继续读
2. **每个目录必须有 INDEX.md** — 不要让 Agent 自己翻文件列表
3. **YAML frontmatter 必须** — 至少 tags + status + created
4. **文件内链接用相对路径** — 例如 `[策略策略](./strategies/v4-reversal.md)`
5. **不存原始日志** — 原始数据放 `raw/` 目录，知识库只存编译后的结论
6. **日期格式** — `YYYY-MM-DD`
