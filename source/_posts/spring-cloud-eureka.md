---
title: 微服务--注册中心(二)
date: 2019-01-23 10:32:01
tags: SpringCloud
categpries: SpringCloud
---
著名的CAP理论，Eureka满足AP理论，ZK、Consul满足CP理论

<!-- more -->
最早接触的是zk，当时没怎么分析，水货
## Zookeeper
### 原理

### 特点


## Eureka
### 原理

### 特点
1. 服务注册快，不需要将注册信息同步到其他节点
2. 不同的节点注册信息可以不一致，保证了高可用A

## Consul
### 原理

### 特点
为了满足强一致性C，导致以下缺点

1. 服务注册慢，必须满足半数的节点写入成功才认为注册成功
2. Leader宕机，为了强一致性，整个集群不可用，牺牲了高可用


## Etcd

## Nacos