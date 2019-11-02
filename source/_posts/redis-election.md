---
title: Redis哨兵机制(七)
date: 2019-06-07 00:18:30
tags: Redis
categpries: Redis
---
redis引入了哨兵机制

<!-- more -->
## 哨兵机制
### 一主一从
启动哨兵机制，可以对主从数据库进行监控

### 一主多从
启动多个哨兵(建议3个，并且使用奇数个哨兵)，可以对主从数据库进行监控，哨兵之间也可以互相通信。
哨兵主要功能：

1. 监控：监控master和slave是否运行正常
2. 提醒：某个redis出现故障，可以发起通知
3. 自动故障转移：当一个master不能正常工作时，将master下其中一个slave转为master

补充：为什么哨兵至少3个？


### 原理
每个哨兵会向其它哨兵、master、slave定时发送消息，保持心跳。如果指定时间未回应，则认为对方**主观下线**；若多数哨兵都认为某一服务没响应，则认为**客观下线**

## Gossip协议
用于接收master是否下线的消息


## 选举master协议
用来决定是否执行故障转移，以及slave中的选主
选主会有两个过程：

### Sentinel哨兵选出leader
当某个哨兵节点确认master主管下线后，发出广播请求其它哨兵选举自己为leader，
被请求的哨兵如果没有选举过其它哨兵的请求，则同意该请求，否则不同意
当哨兵节点票数达到Max(quorum, num(sentinel)/2 + 1)，则升级为leader

### Sentinel Leader选举主节点master
master选举：
<image src="https://impwang.oss-cn-beijing.aliyuncs.com/redis/redis-leader.png"/>

slave-priority在conf中配置