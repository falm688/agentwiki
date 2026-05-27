---
tags: [database, ta, pro, reconciliation, tax]
status: active
created: 2026-05-26
source_file: TA&&pro核对补充.xlsx
---

# TA&&Pro 核对补充

**一句话结论：TA系统与Pro系统之间的字段核对文档，以非居民涉税申请信息表（TNONRESIRREQUEST）为例，展示了TA字段与Pro字段的映射关系。**

## 版本信息

- **对象号**: T-01010
- **表名**: TNONRESIRREQUEST
- **说明**: 非居民涉税申请信息
- **来源文件**: TA&&pro核对补充.xlsx

## 字段映射示例

| 中文名 | TA字段名 | 字段类型 | 空值 | 字段注释 | Pro字段名 |
|:---|:---|:---|:---|:---|:---|
| 申请单编号 | C_REQUESTNO | VARCHAR2(24) | NOT NULL | - | app_sheet_serial_no |
| 交易发生日期 | D_REQUESTDATE | CHAR(8) | NOT NULL | - | transaction_date |
| 交易发生时间 | D_REQUESTTIME | VARCHAR2(6) | NOT NULL | - | transaction_time |
| 销售人代码 | C_AGENCYNO | VARCHAR2(9) | NOT NULL | - | distributor_code |
| 网点号码 | C_NETNO | VARCHAR2(9) | NOT NULL | - | - |
| 投资人基金账号 | C_FUNDACCO | VARCHAR2(12) | - | - | ta_account_id |
| 个人/机构标志 | C_CUSTTYPE | CHAR(1) | NOT NULL | 0:机构;1:个人;2:产品 | cust_type |
| 调查规则 | C_SURVEYMETHOD | CHAR(1) | NOT NULL | 0:新开账户;1:存量账户 | - |
| 取得投资人声明标识 | C_GETINVESTCERFLAG | CHAR(1) | NOT NULL | 0:否;1:是 | - |
| 非居民标识 | C_NONRESIFLAG | CHAR(1) | NOT NULL | 0:仅中国税收居民;1:仅非居民;2:同为两国税收居民;3:不配合客户 | - |

## 关键映射规则

- **TA字段命名**: 大写 + 下划线分隔（如 `C_REQUESTNO`）
- **Pro字段命名**: 小写 + 下划线分隔（如 `app_sheet_serial_no`）
- **日期字段**: TA用 `CHAR(8)`，Pro用对应语义名称
- **标志字段**: 均有详细枚举值注释

## 相关页面

- [TA系统文档索引](./INDEX.md)
- [TA4.0数据库设计](./ta4-database.md)
- [涉税接口规范](./interface-tax.md)
