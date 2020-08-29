---
title: 微服务--路由器(五)
date: 2019-06-12 00:53:57
tags:
categpries: SpringCloud
---
在wei服务中刚开始使用dubbo通信，后来改为ribbon/feign，feign实际上是在ribbon上又封装了一层

<!-- more -->
## Ribbon

### 负载均衡
#### 轮询策略
#### 随机策略
#### 可用过滤策略(AvailabilityFilteringRule)
过滤掉连接失败的服务节点，并且过滤掉高并发的服务节点，然后从健康的服务节点中，使用轮询策略选出一个节点返回。

#### 响应时间权重策略(WeightedResponseTimeRule)
根据响应时间，分配一个权重weight，响应时间越长，weight越小，被选中的可能性越低。

#### 轮询失败重试策略(RetryRule)
首先使用轮询策略进行负载均衡，如果轮询失败，则再使用轮询策略进行一次重试，相当于重试下一个节点，看下一个节点是否可用，如果再失败，则直接返回失败。

重试的时间间隔，默认是500毫秒

#### 并发量最小可用策略（BestAvailableRule）
选择一个并发量最小的server返回。
如何判断并发量最小呢？ServerStats有个属性activeRequestCount，这个属性记录的就是server的并发量。轮询所有的server，选择其中activeRequestCount最小的那个server，就是并发量最小的服务节点。

#### ZoneAvoidanceRule
策略描述：复合判断server所在区域的性能和server的可用性，来选择server返回。

### 自定义负载均衡策略

## Feign


## OpenFeign
