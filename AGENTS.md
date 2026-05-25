# 交易与学习知识库 — AGENTS.md

> 本文件供 AI Agent 读取，了解知识库结构和规范。

## Vault 位置

```
本地路径: /Users/falm/wiki/agnetwiki/
环境变量: $WIKI
快捷链接: ~/wiki
GitHub:   https://github.com/falm688/hermes-trading-wiki
```

## 领域目录

| 子目录 | 领域 | 维护者 |
|:---|:---|:---|
| `a-stock/` | A股量化交易 | Alex (Hermes) |
| `btc/` | BTC 加密货币 | BTC Agent |
| `learning/` | 个人学习 | 学习导师 |

## 作为 Agent 的读/写规范

1. **只看自己的目录** — 不要越界读写其他 Agent 的领域
2. **格式** — 每个文件必须含 YAML frontmatter：`tags` / `status` / `created`
3. **结论置顶** — 文件第一行用加粗写一句话结论
4. **每个目录有 INDEX.md** — 让其他 Agent 知道里面有什么
5. **写之前 `git pull`，写之后 `git push`**
