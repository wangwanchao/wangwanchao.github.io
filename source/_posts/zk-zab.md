---
title: ZooKeeper原子广播协议ZAB(二)
date: 2019-04-12 15:45:43
tags: ZooKeeper
categpries: ZooKeeper
---
ZAB 源自一致性协议

<!-- more -->
## Paxos协议 ##
Paxos(帕索克斯)：
Chubby技术架构

## ZAB协议 ##
ZAB(Zookeeper Atomic Broadcast)：ZooKeeper原子消息广播协议，因为paxos太过于复杂，zk基于paxos实现了ZAB协议

### 特性
1. 保证各个服务器之间的数据一致性
2. leader节点无法工作后，ZAB协议自动从Follower节点中选举新的leader

### 写操作
写请求分为leader、follower/observer两种接收
#### 写leader




#### 写follower/observer
follower/observer接收到写请求都会转发到leader，再由leader
做一些ACK机制处理

### 读操作
leader/follower/observer都可以处理读请求，直接返回结果给客户端

## 数据一致性问题
因为leader负责写操作，leader随时可能挂掉，接着进入选举过程，这个期间如何保证数据一致性

leader可能挂掉的场景：

1. 数据到达Leader节点前
2. 数据到达 Leader 节点，但未复制到 Follower 节点
3. 数据到达 Leader 节点，成功复制到 Follower 所有节点，但还未向 Leader 响应接收
4. 数据到达 Leader 节点，成功复制到 Follower 部分节点，但还未向 Leader 响应接收
5. 数据到达 Leader 节点，成功复制到 Follower 所有或多数节点，数据在 Leader 处于已提交状态，但在 Follower 处于未提交状态
6. 数据到达 Leader 节点，成功复制到 Follower 所有或多数节点，数据在所有节点都处于已提交状态，但还未响应 Client
7. 网络分区导致的脑裂情况，出现双 Leader