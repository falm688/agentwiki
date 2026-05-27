---
tags: [bugfix, v6, hs300, benchmark, drift]
status: active
created: 2026-05-26
---

# 🐛 HS300漂移bug修复记录

**一句话总结**：V6策略用 `self._d + 1581` 硬编码偏移索引HS300预计算数据，到2022年偏移27天，结果虚高+369%（真实约+172%）。修复为按Operator交易日历日期精确查找。

## 根因分析

### 错误代码（原始V6）

```python
def _hs(self):
    return HS300[min(self._d + 1581, len(HS300) - 1)]
```

- `_d`：策略内 `realize()` 调用计数器，每次调用+1
- `1581`：从2014-01-02到2020-07-01的预估交易日数
- 问题：**qteasy内部realize()调用的节奏与实际交易日历不完全对齐**
  - 数据窗口预热（window_length=80天）在正式回测前就调用了realize()
  - 部分非交易日/停牌日的处理不一致
  - 到2022年底，`_d` 比实际交易日历超前了**27天**
  - 到2023年底，超前了**42天**

### 后果

| 版本 | 结果 | 说明 |
|:---|:---:|:---|
| 原始V6（有漂移） | **+369.29%** | _d+1581索引超前 → 读到"未来的"HS300状态 |
| 7段分段（漂移修正） | **+170.81%** | 每段重置offset，按真实验证 |
| **日期查找版（修复后）** | **+172.84%** | ✅ **误差仅1.2%** |

漂移导致 HS300 熔断/MA20 判断在后期读取到未来的数据，使得策略看似"预知"了市场状态，虚增约**196个百分点**收益。

## 修复方案

### 核心思路：按日期查找，放弃 `_d + offset`

qteasy的 `self.group._operator.group_timing_table.index` 提供了完整的交易日历，`_d - 1` 映射到当前位置。

```python
def _current_date(self):
    """通过Operator交易日历获取当前日期（核心修复）"""
    try:
        op = self.group._operator
        idx = self._d - 1
        if 0 <= idx < len(op.group_timing_table.index):
            return op.group_timing_table.index[idx].strftime('%Y-%m-%d')
    except Exception:
        pass
    return None

def _hs(self):
    """按日期查找HS300状态 — 无漂移"""
    dt = self._current_date()
    if dt is None:
        return {'fuse_active': False, 'hs_below_ma20': False}
    return self._hs_by_date.get(dt,
        {'fuse_active': False, 'hs_below_ma20': False})
```

### 数据准备

- `/tmp/hs300_protection.json`：每日HS300熔断状态（3009条，2014-01-02 ~ 2026-05-22）
- `/tmp/dual_strategy_states.json`：每月市场分类器状态（136条，2015-01 ~ 2026-04）
- 策略启动时加载为 `{date: record}` 字典

### 修复验证

```
原始V6（有漂移）: +369.29%
7段分段（无漂移）: +170.81%
日期查找版（修复）: +172.84%
                   └── 误差1.2% ✅
```

HS300基准收益率也从漂移版的失真的读数修正为 `+12.60%`。

## 影响范围

| 组件 | 是否受影响 | 说明 |
|:---|:---:|:---|
| V6策略回测 | ✅ 已修复 | `strategies/active/v6_fixed.py` |
| 双策略DualStrategyV2 | ❌ 不受影响 | 用预计算daily_states列表 + `_d`索引，列表长度=交易日数 |
| daily_monitor | ❌ 不受影响 | 直接查数据库，不走索引偏移 |
| 模拟盘 | ❌ 不受影响 | 每日实时计算，无预计算数据 |

## 教训与启示

1. **永远不要用 `counter + offset` 索引外部预计算数据** — `_d` 和交易日历的映射关系不可靠
2. **按日期（或按数据行数）查找而非按计数器** — 更鲁棒
3. **分段验证是发现漂移的有效手段** — 连续7段 vs 合成结果对比，差异暴露问题
4. **V6的"神话"+369%破灭了**，但+172%仍是一个不错的超额收益（年化18.58%，超额160pp）
   - 但超额的**80%来自2024年**，其他年份平庸，策略稳健性仍需提升
