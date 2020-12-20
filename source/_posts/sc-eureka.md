---
title: 微服务--注册中心(二)
date: 2020-12-13 10:32:01
tags: 注册中心
categpries: SpringCloud
---
著名的CAP理论，Eureka满足AP理论，ZK、Consul满足CP理论。C强一致性，A高可用性，P分区容错性。在多节点的分布式环境中，注册中心还是一个比较复杂的中间件，尤其是要考虑跨区域

<!-- more -->

## Eureka
Eureka不保证强一致性，只保证最终一致性，架构中增加了很多的缓存机制。
### 特点
1. 服务注册快，不需要将注册信息同步到其他节点
2. 不同的节点注册信息可以不一致，保证了高可用A

### 原理

#### Eureka Server
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

##### 缓存机制
`eureka server`维护了3个容器类，用来存储服务信息
registry: 实时更新。web根据该类获取信息。
readWriteCacheMap: 实时更新。每隔30s同步信息到readOnlyCacheMap，每隔60s清除超过90s未续约的节点。
readOnlyCacheMap:周期更新。 eureka client每隔30s根据该类获取信息。

##### 自我保护机制
15min内超过85%的服务不可用，则启动自我保护机制，

#### Eureka Client
eureka client需要注册、续约、更新状态来维持和eureka server的连接。

##### 缓存机制
client有2种角色：服务提供者、服务消费者。
作为提供者，每隔30s向server续约。
作为消费者，启动后立即从sever获取全量服务信息，之后每隔30s从server增量更新注册信息。同时和Ribbon的整合，Ribbon延后1s从client获取状态UP的服务信息，默认每隔30s更新。
`eureka client`维护了3个容器类，用来存储服务信息
localRegionApps: 周期更新。启动后立即从sever获取全量服务信息，之后每隔30s从server增量更新注册信息。
upServerListZoneMap: 周期更新。Ribbon保存使用且状态为UP的服务注册信息，启动后延时1s向Client更新，默认每30s更新。

### 平滑上下线/无感知
由于存在多种缓存机制，在极端情况下，服务从注册到发现需要很长的时间，所以就需要做到无感知上线、下线。如果是服务非正常终止，最坏情况下需要240s发现。
思考的方向：
Eureka Server:
> 减少readWriteCacheMap到readOnlyCacheMap的更新间隔时间。
> 关闭readOnlyCacheMap，使client直接从readWriteCacheMap获取服务信息。

Eureka Client:
> 减少client从server获取服务的更新周期，减少Ribbon从server获取UP服务的更新周期.
> 增加容错机制。配置Retry重试下一个节点
> 保证服务提供者尽量正常下线。

## Zookeeper
### 原理

### 特点


## Consul
### 原理

### 特点
为了满足强一致性C，导致以下缺点

1. 服务注册慢，必须满足半数的节点写入成功才认为注册成功
2. Leader宕机，为了强一致性，整个集群不可用，牺牲了高可用


## Etcd

## Nacos

