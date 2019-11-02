---
title: ZooKeeper基于TCP的FastLeader(四)
date: 2019-06-06 13:57:58
tags: ZooKeeper
categpries: ZooKeeper
---
TCP选举算法

<!-- more -->
## 核心结构

### myid
对应服务器在集群中的唯一ID

### zxid
类似于事务ID，顺序递增

|  高32位  |  低32位  |
epoch_h：用于标记leader的epoch，从1开始，每次选举出新的leader
，epoch_h加1，

epoch_l：用于标记epoch_h内的版本，epoch_h改变后，epoch_l会被重置

### 状态
服务器状态：
looking：
leading：
following：
observing:

### 选票数据结构
选举领导时会进行投票，投票的数据结构：

logicClock: 表示该服务器发起的是第几轮投票，每个服务器都维护一个自增的logicClock
state: 当前服务器状态
self_id: 当前服务器的myid
self_zxid: zxid
vote_id: 被推选的的服务器的myid
vote_zxid: 被推选的服务器zxid

## 选举流程
选举过程很重要，也很复杂，做了一个流程图，不合理的回头补充：

<image src="https://impwang.oss-cn-beijing.aliyuncs.com/zookeeper/FastLeaderElection%E9%80%89%E4%B8%BE%E5%8E%9F%E7%90%86.png"/>

投票过程数据结构: (logicClock, myid, zxid)
投票箱存储结构：(投票服务器id, 被推选服务器id)


