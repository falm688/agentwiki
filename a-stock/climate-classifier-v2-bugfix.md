---
tags: [气候分类器, bug修复, V2版]
status: active
created: 2026-06-02
updated: 2026-06-02
---

# 气候分类器 V2 — 死区bug修复+逻辑重写

> **一句话结论：V1分类器低波区有死区（above_ma60在0.3~0.7范围全部被映射为CASH），导致CASH占比高达43%。V2修复此bug，合理分配为V4=61%/TREND=25%/CASH=14%。**

## 发现的Bug清单

### B1（核心）— 低波区死区导致CASH过度
**位置**：`ClimateClassifier._judge()` 低波动区（vol20≤18%）的 `else` 分支
**代码**：
```python
# V1 低波区
if above_ma60 > 0.7 and trend_strength: return 'TREND'
elif above_ma60 < 0.3 and ret60 < -0.05: return 'CASH'
elif above_ma60 < 0.3: return 'CASH'
else: return 'CASH'  # ← 死区！0.3≤above_ma60≤0.7全部CASH
```
**影响**：HS300在MA60附近震荡时（最常见场景），分类器一律CASH
**修复**：V2在低波区细分5种场景，消除死区

### B2 — `vol_change_5d`是死参数
**位置**：`classify()`中计算但 `_judge()`从未使用
**代码**：
```python
vol_change_5d = ...  # 算了一堆
# 但 _judge 的 vol_change_5d=0.0 默认值覆盖了所有计算
```
**影响**：浪费算力，本应参与波动率方向判断
**修复**：V2低波区加入 `vol_change_5d > 15` 判断趋势突破

### B3 — V1和V2参数扫描inconsistency
**位置**：`sweep_climate_params.py` vs `climate_classifier.py`
**影响**：参数扫描用的简化判定逻辑和实际回测的 `_judge` 不一致，导致扫描结论不可直接迁移
**修复**：V2统一两套逻辑

### B4 — 数据库回测脚本参数不匹配
**位置**：`v4_climate_sql.py`、`v4_climate_trend.py` 的 `ENTRY_DROP`
**代码**：`ENTRY_DROP = 0.12` 但最优参数是 `0.08`
**影响**：回测和实际最优参数不一致

## V2 分类器设计

### 设计原则
1. **3模式输出**：TREND / V4 / CASH（不再有FULL/LIGHT/MICRO等子模式）
2. **无死区**：每个above_ma60范围都有明确映射
3. **vol20边界可调**：默认vol20_low=18%, vol20_high=25%, vol20_extreme=35%
4. **vol_change_5d参与决策**：低波区用来判断趋势突破

### V2判定树（精简版）

```
极端波动 (vol20>35%):
  above_ma60>0.5 → V4
  price_vs_ma60<-10% → CASH   (恐慌性暴跌)

高波动 (25%<vol20≤35%):
  一律 V4  ← V4黄金期

中波动 (18%<vol20≤25%):
  above_ma60>0.7 + trend + mom>0 → TREND
  above_ma60>0.7但trend弱 → V4
  above_ma60<0.3 → V4
  均线附近 → 看动量方向

低波动 (vol20≤18%):
  above_ma60>0.7 + trend → TREND
  above_ma60>0.7但trend弱 → 看vol_change(突破→TREND/震荡→V4)
  above_ma60<0.3 + 阴跌(ret60<-5%) → CASH
  above_ma60<0.3 + 接近均线 → V4
  均线附近(0.3~0.7):
    近期涨→TREND
    平盘微跌→CASH
    下跌→V4
```

### V1 vs V2模式分布（2020-2026）

| 指标 | V1旧版 | V2新版 | 变化 |
|:----|:-----:|:-----:|:----:|
| **V4** | 26.0% | **60.8%** | ✅ +34.8pp |
| **TREND** | 31.2% | 24.8% | -6.4pp |
| **CASH** | **42.9%** | **14.4%** | ✅ -28.5pp |

### 逐年V2分布

| 年份 | V4 | TREND | CASH | 评价 |
|:---|:--:|:-----:|:----:|:-----|
| 2020 | 56% | 40% | 4% | ✅ 疫情反弹TREND足 |
| 2021 | 73% | 16% | 12% | ✅ V4主场 |
| 2022 | 69% | 15% | 16% | ✅ 熊市有保护 |
| 2023 | 50% | 18% | 33% | ✅ 阴跌年CASH足够 |
| 2024 | 60% | 14% | 27% | ✅ V4爆发足够 |
| 2025 | 58% | 40% | 2% | ✅ 慢牛TREND抓住 |
| 2026 | 61% | 39% | 0% | ✅ 趋势为主 |

## 文件变更

| 文件 | 变更 |
|:----|:----|
| `strategies/active/climate_classifier.py` | 完整重写V2 |
| `strategies/active/v4_climate_sql.py` | calc_climate同步V2 |
| `strategies/active/v4_climate_trend.py` | calc_climate+get_mode同步V2 |
| `strategies/active/sweep_climate_params.py` | 需同步（待做） |

## 下一步

V2分类器改变了策略活动的分布（V4从26%→61%），意味着**之前为V1优化的参数（ED=8%/TP=12%/SL=12%/HD=25）不再是最优**。需要做一次新的参数扫描来匹配V2分类器的活动分布。

## 参考

- `strategies/active/climate_classifier.py` — V2代码
- `right-side-strategy` skill — 策略框架
