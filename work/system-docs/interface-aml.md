---
tags: [interface, ta, fund, aml, compliance]
status: active
created: 2026-05-26
source_file: 登记过户系统与客户服务系统接口规范_反洗钱信息接口.doc
---

# 登记过户系统与客户服务系统接口规范 — 反洗钱信息接口

**一句话结论：TA系统向客服系统报送反洗钱统一报告标准信息，以文本文件定长记录方式传输，包含个人和机构投资者的完整身份信息。**

## 版本信息

- **来源文件**: 登记过户系统与客户服务系统接口规范_反洗钱信息接口.doc
- **文件大小**: 379,904 bytes
- **新增日期**: 2019-07-26

## 数据处理规则

与客服系统接口规范一致：
- 文本文件定长记录
- 新增字段增加在尾部，客服系统不校验记录长度
- 第一行: 数据记录数
- 最后一行: `END`
- 换行: 回车(0DH) + 换行(0AH)
- 数字左补零右对齐，字符右补空格左对齐
- 小数点不传，默认2位小数
- 负数第一位用 `-` 表示

## 更新规则

- **频率**: 每日一次
- **范围**: 截至当日做完登记过户操作后的投资人信息
- **模式**: 每次只提供当天报送（新增/更新）的全部数据及结果

## 数据文件

| 文件 | 说明 |
|:---|:---|
| `AMLX1Currents_yyyymmdd.txt` | 个人投资者反洗钱流水 |
| `AMLX3Currents_yyyymmdd.txt` | 机构和产品投资者反洗钱流水 |

## 关键字段（个人投资者）

| 字段 | 说明 |
|:---|:---|
| AppSheetSerialNo | 申请单编号 |
| TransactionDate | 交易发生日期 |
| TransactionTime | 交易发生时间 |
| DistributorCode | 销售人代码 |
| BranchCode | 场内填写席位代码 |
| TAAccountID | 投资人基金帐号（场内填证券账号） |
| IndividualOrInstitution | 0-机构，1-个人，2-产品 |
| OriginalAppDate | 原申请日期（新开户必填） |
| OriginalAppSheetNo | 原申请单编号 |
| InvestorName | 投资人户名 |
| CertificateType | 证件类型 |
| CertificateNo | 证件号码 |
| CertValidDate | 证件有效日期（长期有效填99991231） |
| InvestorsBirthday | 出生日期 |
| Nationality | 国家/地区（ISO 3166两位字母） |
| VocationCode | 职业代码 |
| MobileTelNo | 手机号（格式: 国家码\|手机号，如 86\|13601223345） |
| HomeTelNo | 住址电话（格式: 国家码\|地区码\|电话号码） |
| OfficeTelNo | 单位电话 |
| EmailAddress | E-MAIL |
| FaxNo | 传真 |
| PostCode | 邮政编码 |
| AnnualIncome | 年收入（元，区间填上限） |
| LivingCountry | 现居国家/地区（ISO 3166） |
| LivingAddress | 现居地址（格式: 省\|市\|县\|街道，境内必填） |
| RegRegionCode | 注册地国家/地区代码 |
| LivingAddress2 | 现居地址2（工作单位地址） |
| CorpName | 工作单位名称 |
| SpecialPersonFlag | 特定自然人标识 |

## 地址格式规范

**境内地址**（省|市|县|街道）：
- 省、市、县：填写民政部最新行政区划代码（六位数字）
- 境外地址：省、市、县不填，街道填完整地址

## 关键要点

- 手机号、住址电话、单位电话至少必填其一
- 证件长期有效填写 `99991231`
- 年收入按区间填写上限（如 0-10万填 100000）
- 新开户尚未获得基金账号时，TAAccountID 可填空，但须填报原申请日期和原申请单编号

## 相关页面

- [TA系统文档索引](./INDEX.md)
- [TA与客服系统接口规范（恒生）](./interface-cs-hengshneg.md)
- [涉税接口](./interface-tax.md)
