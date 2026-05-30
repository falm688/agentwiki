---
tags: code-audit, phase5, cleanup
created: 2026-05-30
---

# 代码审计修复 + Phase 5 改进

> 2026-05-30 完成修复

## 修复清单

| 问题 | 修复方式 | 状态 |
|:----|:--------|:----:|
| `core/data.py` vs `core/data_loader.py` 重复 | data.py加废弃警告 | ✅ |
| `core/simulator.py` vs `core/simulator_v2.py` 重复 | simulator.py加废弃警告 | ✅ |
| DB密码硬编码 | 统一到 `core/config.py`，支持环境变量覆盖 | ✅ |
| 策略资金¥100k硬编码 | 统一到 `core/config.py`，`STRATEGY_CONFIGS` 字典 | ✅ |
| 无Walk-Forward验证 | 新增 `core/walk_forward.py`：滚动窗口+参数优化 | ✅ |
| 无系统健康检查 | 新增 `tools/daily_health_check.py` + Cron (20:30) | ✅ |

## 新增文件

| 文件 | 作用 |
|:----|:------|
| `core/config.py` | 统一配置：DB连接、策略资金、费率、路径 |
| `core/walk_forward.py` | Walk-Forward交叉验证：滚动窗口+参数搜索+一致性评分 |
| `tools/daily_health_check.py` | 每日健康检查：MySQL/数据新鲜度/状态一致性/净值连续性 |

## 新增Cron

| Cron | 时间 | 功能 |
|:----|:----|:-----|
| 🔍 每日健康检查 | 20:30 工作日 | 自动检测异常推飞书 |

## 测试

- 384个测试全通过 ✅
- 废弃代码向后兼容（旧脚本不受影响）
