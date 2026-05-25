---
tags: [interview, python, p0]
status: active
created: 2026-05-25
---

# Python 基础八股题库

**一句话结论：P0 阶段需掌握 20 道 Python 基础面试题，每天 15 分钟滚动复习。**

## Week 1：Python 基础类型（5道）

### Q1：Python中 `is` 和 `==` 的区别是什么？

难度：🟢 简单 | 出现频率：90%

**答案要点：**
- `==` 比较值（调用 `__eq__`）
- `is` 比较内存地址（`id()`）
- 小整数缓存（-5~256）导致 `is` 可能为 True
- 字符串驻留导致部分字符串 `is` 为 True

**代码示例：**
```python
a = [1, 2, 3]
b = [1, 2, 3]
print(a == b)  # True
print(a is b)  # False

c = 256
d = 256
print(c is d)  # True（缓存）
```

**延伸问题：**
- 什么情况下应该用 `is` 而不是 `==`？（None、True、False 判断）
- 小整数缓存的范围是多少？为什么设计这个机制？（性能优化，常用数字）

---

### Q2：列表、元组、集合的区别和使用场景？

难度：🟢 简单 | 出现频率：85%

**答案要点：**

| 特性 | 列表 | 元组 | 集合 |
|:---|:---|:---|:---|
| 可变 | ✅ | ❌ | ✅ |
| 有序 | ✅ | ✅ | ❌ |
| 重复 | ✅ | ✅ | ❌ |
| 查找 | O(n) | O(n) | O(1) |
| 使用场景 | 动态数据 | 固定配置 | 去重/成员判断 |

**延伸问题：**
- 元组真的不可变吗？（嵌套可变对象的情况）
- 集合为什么查找是 O(1)？（哈希表实现）

---

### Q3：深拷贝和浅拷贝的区别？

难度：🟡 中等 | 出现频率：80%

**答案要点：**
- 浅拷贝（`copy.copy`）：创建新对象，但内部元素共享引用
- 深拷贝（`copy.deepcopy`）：递归创建所有对象，完全独立
- 切片 `[:]`、`list()` 是浅拷贝

**代码示例：**
```python
import copy
a = [[1, 2], [3, 4]]
b = copy.copy(a)      # 浅拷贝
c = copy.deepcopy(a)  # 深拷贝

b[0].append(5)
print(a)  # [[1, 2, 5], [3, 4]] — a 也被改了！
print(c)  # [[1, 2], [3, 4]] — c 独立
```

---

### Q4：Python 的 GIL 是什么？有什么影响？

难度：🟡 中等 | 出现频率：75%

**答案要点：**
- GIL（Global Interpreter Lock）：全局解释器锁
- 保证同一时刻只有一个线程执行 Python 字节码
- 影响：多线程不能利用多核 CPU（CPU 密集型）
- 解决：多进程（`multiprocessing`）、C 扩展、其他解释器（Jython）
- IO 密集型任务不受 GIL 影响（线程切换释放 GIL）

**延伸问题：**
- 为什么要有 GIL？（简化内存管理，避免竞争条件）
- Python 3.13 的 nogil 进展？

---

### Q5：装饰器是什么？写一个计时装饰器

难度：🟡 中等 | 出现频率：70%

**答案要点：**
- 装饰器是接收函数作为参数并返回函数的函数
- 本质是语法糖：`@decorator` 等价于 `func = decorator(func)`
- 用 `functools.wraps` 保留原函数元信息

**代码示例：**
```python
import time
from functools import wraps

def timer(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        print(f'{func.__name__} took {time.time() - start:.2f}s')
        return result
    return wrapper

@timer
def slow_function():
    time.sleep(1)
```

**延伸问题：**
- 带参数的装饰器怎么写？
- 类装饰器和函数装饰器的区别？

---

## 使用说明

1. 每天学习后花 15 分钟看 1 道八股题
2. 先自己回答，再看答案
3. 把答案用自己的话复述一遍
4. 记录不熟悉的题目，周末复习
5. 每周新增 5 道，滚动复习

## 掌握标准

- 🟢 能流利回答，不需要思考 → 已掌握
- 🟡 能回答但不够完整 → 需复习
- 🔴 完全不会或答错 → 重点标记

每周日自评一次，标记掌握状态。
