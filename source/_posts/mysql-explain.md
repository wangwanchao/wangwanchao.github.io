---
title: MySQL执行计划
date: 2018-09-21 10:45:25
tags: 执行计划,优化
categories: MySQL
---



<!-- more -->

## 库表结构设计优化 ##



## 索引优化 ##

## 查询优化 ##

### 1、LIKE ###

	SELECT column FROM table WHERE field LIKE '%keyword%';

两边都有‘%’不走索引

	SELECT column FROM table WHERE field LIKE 'keyword%';

左边没有‘%’，才会走索引

可以通过explain执行计划查看，

优化替代方案：

1. LOCATE('substr', field, pos)
2. POSITION('substr' IN field)
3. INSTR(field, 'substr')
4. FIND_IN_SET('substr', field)



### 2、IN、NOT IN ###



### 3、int/datetime/timstamp时间存储

对于MyISAM引擎，不建立索引的情况下（推荐），效率从高到低：

	int > UNIX_TIMESTAMP(timestamp) > datetime（直接和时间比较）>timestamp（直接和时间比较）>UNIX_TIMESTAMP(datetime) 。

对于MyISAM引擎，建立索引的情况下，效率从高到低： 
	
	UNIX_TIMESTAMP(timestamp) > int > datetime（直接和时间比较）>timestamp（直接和时间比较）>UNIX_TIMESTAMP(datetime) 。

对于InnoDB引擎，没有索引的情况下(不建议)，效率从高到低：

	int > UNIX_TIMESTAMP(timestamp) > datetime（直接和时间比较） > timestamp（直接和时间比较）> UNIX_TIMESTAMP(datetime)。

对于InnoDB引擎，建立索引的情况下，效率从高到低：

	int > datetime（直接和时间比较） > timestamp（直接和时间比较）> UNIX_TIMESTAMP(timestamp) > UNIX_TIMESTAMP(datetime)。
	

### 4、固定长度的表更快

避免VARCHAR、TEXT、BLOB字段
