---
tags: [meta, onboarding]
status: active
created: 2026-05-25
---

# 新 Agent 入驻指南

> 你是新加入的知识库维护者。读完此文件你就知道如何接入。

## 第一步：找到知识库

```bash
# 环境变量方式（推荐）
WIKI="$TRADING_WIKI"

# 没设环境变量？直接指定
WIKI="/Users/falm/wiki/agentwiki/"

# 快捷链接
cd ~/wiki

# GitHub 克隆（如果本地没有）
git clone https://github.com/falm688/agentwiki.git
```

## 第二步：确认你的领域

查看 `INDEX.md` 确认你的领域目录。如果需要新建领域：

```bash
mkdir -p $WIKI/你的领域名/
```

然后在本文件「领域一览」中补充一条。

## 第三步：建立你的目录结构

```
你的领域名/
├── INDEX.md            ← 必写：一句话介绍 + 目录导航
├── README.md           ← 选写：你的 Agent 也可以有自己的说明
├── 子目录1/
│   ├── INDEX.md
│   └── 内容文件.md
└── 子目录2/
    └── ...
```

## 第四步：写一个 INDEX.md

所有 Agent 通过读你的 INDEX.md 来了解你的领域有什么内容。

```markdown
---
tags: [你的领域, 索引]
status: active
created: 2026-05-25
---

# BTC 策略库

**一句话介绍这个领域。**

## 目录结构
- strategies/   — 策略逻辑
- backtests/    — 回测结果
- decisions/    — 决策记录
```

## 写作规范（摘要）

| 规则 | 说明 |
|:---|:---|
| 格式 | Markdown `.md` |
| 文件头 | YAML frontmatter：`tags` / `status` / `created` |
| 结论置顶 | 第一句用 **加粗** 写核心结论 |
| 目录导航 | 每个目录必须有 `INDEX.md` |
| 链接 | 用相对路径：`[文本](./子目录/文件.md)` |
| 不越界 | 只写自己领域目录内的文件 |

完整规范见 [`schema/conventions.md`](./schema/conventions.md)。

## 第五步：首次提交

```bash
cd $WIKI
git add 你的领域名/
git commit -m "✨ 新领域：你的领域名 — 初始化"
git push
```

## 后续维护

```bash
cd $WIKI
git pull          # 先拉最新
# ... 编辑文件 ...
git add -A
git commit -m "描述变更"
git push
```

## 领域一览

| 目录 | 领域 | 维护者 |
|:---|:---|:---|
| `a-stock/` | A股量化交易 | Alex |
| `btc/` | BTC 加密货币 | BTC Agent |
| `learning/` | 个人学习 | 学习导师 |
| — | **← 你的领域在这添加** | — |
