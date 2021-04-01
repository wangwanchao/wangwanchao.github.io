---
title: Kafka环境搭建
date: 2020-12-21 22:38:34
tags: Kafka
categories: Kafka
---
17年使用消息队列时接触到Apache Apollo，是IBM用Scala语言开发的，适用于物联网行业。kafka作为消息队列，大多使用在互联网行业，幸运的是也是用Scala语言开发的。

<!-- more -->

## 单节点Kafka ##
Kafka是依赖于Scala语言的，所以要先安装Scala。

### Linux安装
```
kafka_2.11-2.0.0.tgz
tar -xzvf kafka_2.11-2.0.0.tgz
mv kafka_2.11-2.0.0.tgz kafka
```

### 启动zk

#### 使用独立的zk

#### 使用kafka内嵌的zk
启动zk
```
bin/zookeeper-server-start.sh -daemon config/zookeeper.properties

nohup bin/zookeeper-server-start.sh -daemon config/zookeeper.properties &
```

### 启动Kafka，同时注册到zk上
```
bin/kafka-server-start.sh config/server.properties

nohup bin/kafka-server-start.sh config/server.properties &
```

### 创建topic(test)
```
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
```

### 查看topic
```
bin/kafka-topics.sh --zookeeper localhost:2181 --list

bin/kafka-topics.sh --zookeeper 127.0.0.1:2181 --topic test --describe

```

消费者分组
```
bin/kafka-consumer-groups.sh --bootstrap-server 127.0.0.1:9092 --list

bin/kafka-consumer-groups.sh --bootstrap-server 127.0.0.1:9092 --group test_group --describe

# 从头开始消费
/usr/local/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test -group test_group --from-beginning
```

### 生产消息(可以新起一个terminal)
```
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test 
```

### 消费消息(新起一个terminal)

旧版本
```
bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic test --from-beginning
```
新版本
```
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning
```
**注意：**这里可能会遇到问题，旧版本启动参数和新版本参数不一样，根据提示修改即可

## Kafka和zk的关系 ##

Kafka是一个分布式消息系统，多broker就需要一个管理中心，zk作为注册中心，所有的broker、topics都会注册到zk上，进入zk可以看一下：

```
bin/zookeeper-shell.sh localhost:2121
```

查看根节点：
```
ls /
cluster, controller, controller_epoch, brokers, zookeeper, admin, isr_change_notification, consumers, log_dir_event_notification, latest_producer_id_block, config]
```

查看brokers节点：
```
ls /brokers
[ids, topics, seqid]
```

查看broker0:
```
get /brokers/ids/0
{"listener_security_protocol_map":{"PLAINTEXT":"PLAINTEXT"},"endpoints":["PLAINTEXT://localhost:9092"],"jmx_port":-1,"host":"localhost","timestamp":"1535447121995","port":9092,"version":4}
cZxid = 0x2e
ctime = Tue Aug 28 17:05:22 CST 2018
mZxid = 0x2e
mtime = Tue Aug 28 17:05:22 CST 2018
pZxid = 0x2e
cversion = 0
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x1657f0bf1b60003
dataLength = 188
numChildren = 0
```

查看topics:
```
ls /brokers/topics
[test, __consumer_offsets]
```

查看主题test:
```
get /brokers/topics/test             
{"version":1,"partitions":{"0":[0]}}
cZxid = 0x38
ctime = Tue Aug 28 17:06:39 CST 2018
mZxid = 0x38
mtime = Tue Aug 28 17:06:39 CST 2018
pZxid = 0x3a
cversion = 1
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 36
numChildren = 1
```

## 单节点安全机制


## 集群模式 ##