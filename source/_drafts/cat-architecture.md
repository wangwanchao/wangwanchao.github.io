---
title: cat-architecture
date: 2019-01-07 17:07:47
tags:
categpries:
---

## 应用场景

1. 一段代码的执行时间，一段代码可以是URL执行耗时，也可以是SQL的执行耗时。
2. 一段代码的执行次数，比如Java抛出异常记录次数，或者一段逻辑的执行次数。
3. 定期执行某段代码，比如定期上报一些核心指标：JVM内存、GC等指标。
4. 关键的业务监控指标，比如监控订单数、交易额、支付成功率等。

### 埋点
1. HTTP/REST、RPC/SOA、MQ、Job、Cache、DAL;
2. 搜索/查询引擎、业务应用、外包系统、遗留系统;
3. 第三方网关/银行, 合作伙伴/供应商之间；
4. 各类业务指标，如用户登录、订单数、支付状态、销售额。


## 模块
cat-client

cat-consumer

cat-home

## 组件

Transaction

Event

Heartbeat

Metric


