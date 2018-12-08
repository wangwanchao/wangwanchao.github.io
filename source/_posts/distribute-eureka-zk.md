---
title: distribute-eureka-zk
<<<<<<< HEAD
date: 2018-12-02 21:12:08
tags: Java
categpries: Java
---
分布式服务发现比较常用的就是Eureka、Zookeeper，如今Eureka2.0也已经停止维护，虽然不影响生产上的使用，回头还是要补一下Consule服务发现。

## Zookeeper ##



## Eureka ##


=======
date: 2018-12-04 14:42:05
tags: java
categpries: 分布式
---
服务注册中心的组件主要有：Eureka、Zookeeper、Consule、Etcd。都是围绕CAP理论，P是必须保证的，而C和A不能同时满足。zk保证的是CP，Eureka保证的是AP。它们的原理都是维护一张注册列表，客户端在服务列表中查询服务端信息，进行通信
<!-- more -->

### zk保证CP的原理
zk集群需要维护一个leader，当master选举过程中，整个集群不可用，无法注册服务，无法保证A可用性

### Eureka保证AP的原理
Eureka
集群没有leader的概念，所有节点都是平等的，当某一个节点不可用时，会自动切换到其它可用的节点上。这样无法保证C一致性

Eureka还有一种自我保护机制，当在15min之内超过85%的节点没有正常的心跳，eureka会认为出现网络故障：

> 长时间没有心跳时，eureka不会从注册列表移除服务
> 
> eureka节点仍然能接受新服务的注册、查询，不会被同步到其它节点
> 
> 网络恢复时，同步注册信息到其它节点

**当所有Eureka节点/ZK节点挂掉后，RPC是否可以进行正常通信？**
>>>>>>> 811e6bd830e98ed64c74fa5e0917ff8568625b5f

