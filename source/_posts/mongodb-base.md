---
title: MongoDB基础环境搭建
date: 2018-09-04 23:49:13
tags: MongoDB
categories: MongoDB
---
可以说2015年开始接触mongodb，记得那时候看node.js比较多，那时候node.js还是0.x版本...如今早已物是人非。

<!-- more -->

## tar.gz安装 ##

安装
	
	tar -xzvf mongodb-linux-x86_64-rhel70-4.0.2.tgz

	mv mongodb-linux-x86_64-rhel70-4.0.2 mongodb

	mkdir -p /data/db

后台启动服务

	cd mongodb/bin

	./mongod &

进入REPL(Read-Eval-Print Loop)， 即交互式命令行shell

	cd mongodb/bin

	./mongo

> show dbs
> 
> use local
> 
> db