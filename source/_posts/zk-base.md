---
title: ZooKeeper环境搭建
date: 2018-08-28 17:51:15
tags: zookeeper
categories: zookeeper
---
Zookeeper环境搭建，把以前的东西整理一下，

## 单节点环境 ##

单节点的安装可以增加用户，而不是使用root用户启动。

1. 下载安装包、解压缩

	zookeeper-3.4.10.tar.gz

<!-- more -->

2. 修改配置文件zoo.cfg

	zk提供了zoo_sample.cfg在conf目录下，可以增加data、log目录，也可以直接使用模板文件。

		cp zoo_sample.cfg zoo.cfg
	

3. 启动服务端server

	服务端启动可以默认启动
	
		bin/zkServer.sh start

4. 启动客户端client

	客户端可以默认启动，也可以指定服务器参数

		bin/zkCli.sh

		bin/zkCli.sh -server 127.0.0.1:2181
	
	1). 创建节点
	
	语法 

		create [-s] [-e] path data acl

	"-s"表示创建一个"有序"节点; "-e"表示创建一个临时节点.【默认为持久性节点】

		create /test null  
		create -s /test null 

	ACL授权方式为"digest",其中授权的用户名:密码为"test:Kk3Nr5X06NH+XdlGMyOrULgK/mo=",ACL的权限列表为"r""w""c""d""a".

		create -s /test null digest:test:Kk3Nr5X06NH+XdlGMyOrULgK/mo=:rwcda
		create /mykey1 myvalue1
		create /mykey2 myvalue2	

	2). 删除节点

	删除所有节点

		rmr <path>    #删除"/test"以及其下的所有子节点.

	删除指定节点 

		delete <path> [version]

		delete /test -1   #如果此path下还有子节点,将导致删除失败.这是和"rmr"指令的区别.

	3). 修改节点
		
		set path data [version]

		set /test 1313131 -1  #如果版本号为"-1"表示更新时忽略版本校验.

	节点设置ACL权限

		setAcl path acl

		setAcl /test digest:test:Kk3Nr5X06NH+XdlGMyOrULgK/mo=:rwcda 
		

	4). 查看节点数据

		get /mykey1

	5). 添加授权信息

## 集群环境 ##