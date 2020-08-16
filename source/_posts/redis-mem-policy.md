---
title: Redis内存策略(三)
date: 2018-12-16 21:59:23
tags: 内存
categpries: Redis
---
Redis用于缓存的内存不足时，如何处理新写入需要申请额外空间的数据。

<!-- more -->

**32bit系统最大不能超过3G，64bit系统设置为0表示不限制**

设置淘汰策略：
	config get maxmemory
	config get maxmemory-policy

## 分配策略

## 淘汰策略
### 6种淘汰策略

1. volatile-lru:从已设置过期时间的内存数据集中挑选最近最少使用的数据 淘汰；
2. volatile-ttl: 从已设置过期时间的内存数据集中挑选即将过期的数据 淘汰；
3. volatile-random:从已设置过期时间的内存数据集中任意挑选数据 淘汰；
4. allkeys-lru:从内存数据集中挑选最近最少使用的数据 淘汰；
5. allkeys-random:从数据集中任意挑选数据 淘汰；
6. no-enviction(驱逐)：禁止驱逐数据。（默认淘汰策略。当redis内存数据达到maxmemory，在该策略下，直接返回OOM错误）；
