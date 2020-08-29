---
title: 微服务--注册中心(二)
date: 2019-01-23 10:32:01
tags: 注册中心
categpries: SpringCloud
---
著名的CAP理论，Eureka满足AP理论，ZK、Consul满足CP理论。

<!-- more -->
## Zookeeper
### 原理

### 特点

## Eureka
### 特点
1. 服务注册快，不需要将注册信息同步到其他节点
2. 不同的节点注册信息可以不一致，保证了高可用A

### 原理
eureka server集群节点之间都是peer，client向sever注册信息后，接收注册的将信息同步至peer节点。
**注意：这个同步过程是单向的，类似于主从的概念**

服务状态：
|状态|描述|
|:-|:-:|
|UP| 在线 |
|DOWN| 下线 |
|STARTING| 正在启动 |
|OUT_OF_SERVICE| 失效 |
|UNKNOWN| 未知 |

### 缓存机制

### 自我保护机制
15min内超过85%的服务不可用，则启动自我保护机制，

### 平滑上下限/无感知
思考的方向：
Eureka Server:

Eureka Client:

## Consul
### 原理

### 特点
为了满足强一致性C，导致以下缺点

1. 服务注册慢，必须满足半数的节点写入成功才认为注册成功
2. Leader宕机，为了强一致性，整个集群不可用，牺牲了高可用


## Etcd

## Nacos