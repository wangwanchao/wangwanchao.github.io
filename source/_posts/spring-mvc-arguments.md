---
title: Web项目中关于参数的问题
date: 2018-09-20 11:24:01
tags: Spring
categories: Spring
---

## mysql中数值的存储

五大类：

1. 整数类型：BIT、BOOL、TINY INT、SMALL INT、MEDIUM INT、 INT、 BIG INT

2. 浮点数类型：FLOAT、DOUBLE、DECIMAL、Numeric

3. 字符串类型：CHAR、VARCHAR、TINY TEXT、TEXT、MEDIUM TEXT、LONGTEXT、TINY BLOB、BLOB、MEDIUM BLOB、LONG BLOB

4. 日期类型：Date、DateTime、TimeStamp、Time、Year

5. 其他数据类型：BINARY、VARBINARY、ENUM、SET、Geometry、Point、MultiPoint、LineString、MultiLineString、Polygon、GeometryCollection等

|类型|有符号数|无符号数|

|-|:-:|-|


## mysql数据类型和Java数据类型的对应关系
1. BigDecimal在入库的时候，对应mysql中的decimal(decimal(a,b))，同时mysql在设置默认值时，一定要写成'0.00'，而不要使用默认值NULL，否则在加、减、排序容易出错

## Java中常见的问题

1. js解析超大数值精度丢失问题
2. Float和Double不能精确计算价格，建议采用BigDecimal
3. BigDecimal比较0和‘0’的问题

