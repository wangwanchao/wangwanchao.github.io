---
title: 架构基础
date: 2018-09-28 23:53:05
tags: architect
categories: architect
---
经历了一些小系统，"麻雀虽小五脏俱全"，结合自己的经历，谈一些自己的看法。在我看来，架构更多的就是结合不同的业务场景，选择不同的组件去构建一个高可用、高并发、可扩展的系统。

<!-- more -->

# 核心组件 #

## 1、网关 ##

Zuul: 不完全支持异步，需要很好的配合限流熔断，否则容易造成资源耗尽、雪崩效应。

Nginx

Kong

## 2、服务发现 ##

Eureka: 支持跨数据中心高可用，AP最终一致性，不是强一致性。可以结合Ribbon/Feign

Zookeeper:

Etcd:

Consul:

## 2、配置中心 ##

Spring Cloud Config-Server: 只能小规模使用，不建议中大规模使用

携程的Apollo: 

百度的Disconf:

阿里的Diamond:

## 4、认证授权 ##

Spring Security OAuth2:


# 监控组件 #

## 数据总线 ##

Kafka

## 5、日志监控 ##

其实日志监控有很多种组合，ELK是比较常用的组合

ELK

## 6、链路监控 ##

大众点评CAT:

Zipkin: 不够成熟，不能算一款企业级产品

Spring Cloud Seleuth:


## 7、度量监控 Metrics ##

依赖于时序数据库

Prometheus:

InfluxDB:

KairosDB: 基于Cassandra，可以结合Grafana实现界面化展示

OpenTSDB:


## 8、健康检查、告警 ##

Zmon:

Zabbix:


## 9、限流、熔断 ##

Hystrix: 可以结合Turbine实现监控数据流的聚合

