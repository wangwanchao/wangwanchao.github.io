---
title: MongoDB基础环境搭建
date: 2018-09-04 23:49:13
tags: MongoDB
categories: MongoDB
---
可以说2015年开始接触mongodb，记得那时候看node.js比较多，那时候node.js还是0.x版本...如今早已物是人非。

<!-- more -->
## 应用场景
mongodb属于NoSQL数据库，NoSQL分为4种：

1. 键值存储。Memcached/Redis
2. 文档存储。MongoDB/CouchDB
3. 列存储。 Cassandra/Hbase
4. 图形数据库。Neo4j

**注意** MongoDB4.0增加了事务

## Centos7安装

### tar编译安装
	
	tar -xzvf mongodb-linux-x86_64-rhel70-4.0.2.tgz

	mv mongodb-linux-x86_64-rhel70-4.0.2 mongodb

	mkdir -p /data/db

#### 后台启动服务

	cd mongodb/bin

	./mongod &

#### 进入REPL(Read-Eval-Print Loop)， 即交互式命令行shell

	cd mongodb/bin

	./mongo

> show dbs
> 
> use local
> 
> db


## Mac安装

	// 普通安装
	brew install monngodb
	// 添加ssl模块安装
	brew install mongodb --with-openssl
	// 最新开发版本安装
	brew install mongodb --devel

#### 启动REPL客户端
mac默认安装在`/usr/local/Cellar`目录，

	/usr/local/Cellar/mongodb/4.0.3_1/bin/mongo