#!/bin/bash
# wiki-search — 搜索交易知识库
# 用法: wiki-search <关键词>
# 不依赖任何 SDK/框架，纯 grep，任何 Agent 都能用

WIKI="${TRADING_WIKI:-/Users/falm/wiki/agnetwiki}"
query="$*"

if [ -z "$query" ]; then
  echo "用法: wiki-search <关键词>"
  echo "例: wiki-search 结构性熊市"
  echo "例: wiki-search V4 参数"
  exit 1
fi

grep -rn --include="*.md" --include="*.txt" -i "$query" "$WIKI/" \
  | grep -v ".obsidian/" \
  | grep -v "node_modules" \
  | head -30
