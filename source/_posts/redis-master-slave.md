---
title: Redis主从模式
date: 2018-09-01 18:02:23
tags: Redis
categories: Redis
---

## Redis主从复制原理 ##

	Redis使用异步复制
	复制在master和slave是非阻塞模式，即在执行同步时仍然可以提供查询

### Redis复制工作原理： ###

1. 如果设置了一个Slave，无论是第一次连接还是重连到Master，它都会发出一个SYNC命令；
2. 当Master收到SYNC命令之后，会做两件事：
	a) Master执行BGSAVE，即在后台保存数据到磁盘（rdb快照文件）；
	b) Master同时将新收到的写入和修改数据集的命令存入缓冲区（非查询类）；
3. 当Master在后台把数据保存到快照文件完成之后，Master会把这个快照文件传送给Slave，而Slave则把内存清空后，加载该文件到内存中；
4. 而Master也会把此前收集到缓冲区中的命令，通过Reids命令协议形式转发给Slave，Slave执行这些命令，实现和Master的同步；
5. Master/Slave此后会不断通过异步方式进行命令的同步，达到最终数据的同步一致；
6. 需要注意的是Master和Slave之间一旦发生重连都会引发全量同步操作。但在2.8之后版本，也可能是部分同步操作。


### 完全同步、部分同步 ###

psync部分重新同步：是指redis因某种原因引起复制中断后，从库重新同步时，只同步主实例的差异数据(写入指令），不进行bgsave复制整个RDB文件

fullsync导致的问题：复制闪断导致的抖动现象

列举几个fullsync常见的影响：
    master需运行bgsave,出现fork()，可能造成master达到毫秒或秒级的卡顿(latest_fork_usec状态监控)；
    redis进程fork导致Copy-On-Write内存使用消耗(后文简称COW)，最大能导致master进程内存使用量的消耗。(eg 日志中输出 RDB: 5213 MB of memory used by copy-on-write)
    redis slave load RDB过程，会导致复制线程的client output buffer增长很大；增大Master进程内存消耗；
    redis保存RDB(不考虑disless replication),导致服务器磁盘IO和CPU(压缩)资源消耗
    发送数GB的RDB文件,会导致服务器网络出口爆增,如果千兆网卡服务器，期间会影响业务正常请求响应时间(以及其他连锁影响)

psync1的部分同步机制，
	有效解决了网络环境不稳定、redis执行高时间复杂度的命令引起的复制中断，从而导致全量同步。但在应对slave重启和Master故障切换的场景时，psync1还是需进行全量同步。
	
psync2主要让redis在从实例重启和主实例故障切换场景下，也能使用部分重新同步	

部分同步的原理：

1. 主从服务器的复制偏移量offset
2. 主服务器的复制积压缓存区：固定长度的FIFO队列，默认大小1MB
3. PID


从服务器和主服务器进行第一次复制时，主服务器会将自己的运行ID传递给从服务器，从服务器将这个ID保存起来。重连后从服务器将服务器运行ID发送给主服务器，主服务器验证是否是自己的运行ID。

场景1：从服务器断线，重连主服务器

场景2：主服务器宕机，重新启动



命令传播阶段
	
	心跳检测

	

### 主观下线、客观下线 ###



### Sentinel选主 ###

Raft算法实现

### 故障转移 ###


## 主从模式 ##


## 主从从模式 ##

