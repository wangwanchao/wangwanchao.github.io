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

## 内存碎片
redis在清理大量的key之后，原来申请的内存将继续持有而并不会立即释放，此时将会存在大量的内存碎片。
可以通过`info memory`查看内存信息：
```
redis3.x
# Memory
used_memory:879848
used_memory_human:859.23K
used_memory_rss:2646016 			# 实际使用内存
used_memory_rss_human:2.52M			# 申请内存
used_memory_peak:898272
used_memory_peak_human:877.22K
total_system_memory:3956277248
total_system_memory_human:3.68G
used_memory_lua:37888
used_memory_lua_human:37.00K
maxmemory:0
maxmemory_human:0B
maxmemory_policy:noeviction
mem_fragmentation_ratio:3.01		# 碎片率
mem_allocator:libc

redis6.x
used_memory:864920
used_memory_human:844.65K
used_memory_rss:8384512
used_memory_rss_human:8.00M
used_memory_peak:864920
used_memory_peak_human:844.65K
used_memory_peak_perc:100.01%
used_memory_overhead:819922
used_memory_startup:802936
used_memory_dataset:44998
used_memory_dataset_perc:72.60%
allocator_allocated:1007744
allocator_active:1228800
allocator_resident:3506176
total_system_memory:3956277248
total_system_memory_human:3.68G
used_memory_lua:37888
used_memory_lua_human:37.00K
used_memory_scripts:0
used_memory_scripts_human:0B
number_of_cached_scripts:0
maxmemory:0
maxmemory_human:0B
maxmemory_policy:noeviction
allocator_frag_ratio:1.22
allocator_frag_bytes:221056
allocator_rss_ratio:2.85
allocator_rss_bytes:2277376
rss_overhead_ratio:2.39
rss_overhead_bytes:4878336
mem_fragmentation_ratio:10.18
mem_fragmentation_bytes:7560616
mem_not_counted_for_evict:0
mem_replication_backlog:0
mem_clients_slaves:0
mem_clients_normal:16986
mem_aof_buffer:0
mem_allocator:jemalloc-5.1.0
active_defrag_running:0
lazyfree_pending_objects:0
```
redis在4.x版本后才支持碎片整理
```
config get activefrag
config set activefrag yes
```