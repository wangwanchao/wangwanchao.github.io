---
title: mysql读写分离机制
date: 2018-09-08 22:18:37
tags: MySQL
categories: MySQL
---

MySQL读写分离

## MySQL读写分离 ##

从库配置参数：

	--skip-innodb
	--skip-bdb
	--low-priority-updates
	--delay-key-write=ALL

<!-- more -->

## 主从复制的延迟问题 ##

由于服务器负载、网络拥堵等问题，Master和Slave之间数据一致性没有保证。

### 解决方案： ###

1. 在master insert/update操作后强制sleep几秒
2. 把更新的数据保存在内存/或者保存在缓存中(例如redis)，当写操作完成后，读数据直接从缓存中读取。
3. 使用MySQL Proxy代理实现。原理：在master、slave各维护一张count_table表，当master执行insert/delete/update操作时，触发器触发count_table表字段自增。当client请求proxy服务器时，proxy先查询master+slave的count_table表，如果一致，则查询slave，否则查询master

补充：安装MySQL Proxy







