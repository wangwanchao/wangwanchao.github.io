---
title: 分布式之分布式锁
date: 2018-08-28 11:01:29
tags: Java
categories: Java
---
CAP理论：

C Consistency 一致性

A Availability 可用性

P Partition tolerance 容错性

<!-- more -->

## 分布式锁要求： ##

排他性：在同一时间只会有一个客户端能获取到锁，其它客户端无法同时获取

避免死锁：这把锁在一段有限的时间之后，一定会被释放（正常释放或异常释放）

高可用：获取或释放锁的机制必须高可用且性能佳

非阻塞：没有获取到锁直接返回获取锁失败

## 实现方式： ##

1. 基于数据库

	有多种实现方式：
	
		基于乐观锁：通过维护数据的版本号(version)实现
	
		基于悲观锁：select * from tablename for update;
	
	缺点：
		
		数据库的可用性、性能对分布式锁影响很大
		不具备可重入性。锁释放前，行数据一直存在。
		没有锁失效机制。web服务宕机，导致锁未释放
		
		
	

2. 基于Redis、Memcached、tair缓存

	主要依赖于redis自身的原子操作。

	**注意：**redis集群模式的分布式锁，可以采用Redlock机制。对应的Java框架Redisson。

	优点：

	缺点：

3. 基于ZooKeeper

	使用zk的临时节点来实现分布式锁。

	优点：具备高可用、可重入、阻塞锁特性，可解决失效死锁问题。
	
	缺点：因为需要频繁的创建和删除节点，性能上不如Redis方式。
	
	
	[Curator框架](http://curator.apache.org/)


https://blog.csdn.net/xlgen157387/article/details/79036337

https://www.cnblogs.com/austinspark-jessylu/p/8043726.html

https://blog.csdn.net/T1DMzks/article/details/78463098