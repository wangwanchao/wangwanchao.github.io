---
title: Redis新特性概览
date: 2020-08-13 00:37:01
tags:
categpries: Redis
---
"在我的后园，可以看见墙外有两株树，一株zhi是枣树，还有一株也dao是枣树。" --鲁迅《秋夜》
好了，现在看看Redis为什么使用单线程。Redis6.0已经改成多线程了！

<!-- more -->
“纸上得来终觉浅，绝知此事要躬行”。所有的新特性都要亲身体验一下才会更深刻
## Redis3


## Redis4
新特性变更历史：
> 增加内存碎片整理

## Redis5


## Redis6
Redis6对很多关键的地方做了修改，是历史上最大的更新版本
[官方](https://raw.githubusercontent.com/redis/redis/6.0/00-RELEASENOTES)

新特性变更历史：
> 模块系统新增了很多API允许实现一些过去不可能实现的功能。可以在RDB文件中存储任意数据，针对server事件，可以捕获、重写执行命令
> 过期周期重写可以更快地淘汰到期的keys 
> 所有的channel都支持SSL
> ACL权限控制，可以定义users可以只使用某些命令、某些keys
> 新增了协议`RESP3` 
> server端新增对client缓存的支持(仍处于实现性阶段)
> 可以使用多线程处理I/O(选择性)，单实例中pipelining不可用时，每个线程允许2倍的操作
> 支持无磁盘复制，第一次同步加载RDB文件时可以直接从socket加载到内存
> redis-benchmark支持集群模式
> SRANDMEMBER和相同的命令支持更好的分布
> 系统层面支持重写rewritten
> 新增集群代理(redis cluster proxy)

细节：
> ACL LOG:权限控制日志
> client端缓存重新设计：keys命令不再缓存slots；Broadcasting模式；OPTIN/OPTOUT模式
> 持久化较少的实例之间，用于复制的RDB文件被移除
> 
> 新命令：LCS (Longest Common Subsequence)
> 复制过程支持MULTI/EXEC命令
> RDB加载速度提升

> linux/bsd上支持设置'CPU亲缘性'(将4个线程设置在4个CPU上)
> client端缓存：在Server Info中添加'Tracking Prefix Number Stats'
> redis-benchmark增加--user权限控制

> 添加LPOS命令搜索list
> redis-cli端添加TLS参数--pipe, --rdb,  --replica
> 添加TLS会话缓存配置