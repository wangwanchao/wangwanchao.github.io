---
title: ZooKeeper选举过程(五)
date: 2019-06-06 13:36:56
tags: ZooKeeper
categpries: ZooKeeper
---
zk集群有正常启动过程，也会有leader/follower崩溃重启、网络分区问题，这样就导致需要重新选举

<!-- more -->
## 正常集群启动选举


## Leader重启选举
leader由于故障崩溃、或者网络分区导致不可连接。
选举流程图：

<image src="https://impwang.oss-cn-beijing.aliyuncs.com/zookeeper/leader-2.png"/>

## Follower重启选举
follower由于故障崩溃、或者网络分区导致不可连接。
选举流程图：

<image src="https://impwang.oss-cn-beijing.aliyuncs.com/zookeeper/leader-3.png"/>
