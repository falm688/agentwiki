# Hermes 量化交易知识库 — AGENTS.md

> 任何 AI Agent（Claude、GPT、Codex、Gemini 等）接入本知识库时，请先阅读此文件。

## 知识库位置

```
/Users/falm/wiki/agnetwiki/
```

或通过环境变量：
```
$TRADING_WIKI
```

## 快速入门

1. 读 `llms.txt`（30 秒概述）
2. 读 `INDEX.md`（按场景导航）
3. 需要完整上下文读 `llms-full.txt`
4. 搜索特定内容用：`grep -r "关键词" $TRADING_WIKI/`

## 知识结构

| 目录 | 内容 | 谁维护 |
|:---|:---|:---|
| `strategies/` | 策略逻辑（V4 / 右侧） | Agent 写，人类审核 |
| `backtests/` | 回测结果和分析 | Agent 写 |
| `decisions/` | 关键决策记录（按日期） | Agent 写 |
| `raw/` | 原始数据（回测日志等） | 只读，Agent 不写 |
| `schema/` | 写作规范 | Agent 读 |
| `references/` | 参考数据 | 待完善 |

## 写作规范

写新内容前先读 `schema/conventions.md`。

## 文件规范

- 所有文件用 Markdown (`*.md`)
- 必须有 YAML frontmatter（tags/status/created）
- 一句话结论置顶
- 链接用相对路径

## Git 工作流

```bash
cd $TRADING_WIKI
git pull           # 先同步
# ... 编辑文件 ...
git add -A
git commit -m "描述性提交信息"
git push
```
