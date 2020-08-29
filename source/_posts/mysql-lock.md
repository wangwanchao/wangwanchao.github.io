---
title: mysql中的锁lock(三)
date: 2018-08-07 01:04:31
tags: 锁
categories: MySQL
---
MySQL中的锁机制

<!-- more -->
## 锁的分类 ##

### 1. 表级锁(MyISAM)： ###

> 开销小，加锁快
> 
> 不会出现死锁
> 
> 锁定力度大，发生锁冲突概率最高，并发度低

#### 表共享读锁、表独占写锁 ####
	
MyISAM在执行select语句时，会自动给相关表加读锁；
执行insert/update/delete	语句时，自动加写锁；
```
	LOCK tables table1 read local, table2 read local;
	select ***
	select ***
	Unlock tables;
```
local：

锁升级：

### 2. 行级锁(InnoDB)： ###

>开销大，加锁慢
>
>会导致死锁
>
>锁定粒度最小，发生锁冲突最低，并发度也最高

#### 事务ACID ####

原子性

一致性

隔离性

持久性

#### 事务带来的问题 ####

更新丢失

脏读

不可重复度

幻读

#### 事务的隔离级别 ####

1. 加锁
2. MVCC多版本控制

|隔离级别/读数据一致性及允许的并发副作用	|读数据一致性|	脏读	|不可重复读|	幻读|
|-|:-:|:-:|:-:|:-:|
|未提交读(Read uncommitted)|最低级别，只能保证不读取物理上损坏的数据|	是|	是|	是|
|已提交度(Read committed)|	语句级|	否|	是|	是|
|可重复读(Repeatable read)|	事务级|	否|	否|	是|
|可序列化(Serializable)|	最高级别，事务级|	否|	否|	否|

查看系统行级锁占用

	show status like 'innodb_row_lock%';

#### 共享锁(S)、排他锁(X) ####

显式加锁：

	共享锁（S）：SELECT * FROM table_name WHERE ... LOCK IN SHARE MODE
	排他锁（X）：SELECT * FROM table_name WHERE ... FOR UPDATE

#### 意向共享锁(IS)、意向排他锁(IX) ####

这两种锁都是**表锁**

**注意：**只有通过索引条件检索数据，InnoDB才会使用行级锁，否则，InnoDB将使用表锁！


#### 间隙锁 ####

### 3. 页面锁： ###

	> 开锁、加锁时间介于表锁和行锁之间，
	> 
	> 会导致死锁
	> 
	> 粒度介于两者之间，并发度一般

## 实战演练 ##
