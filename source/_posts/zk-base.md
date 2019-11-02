---
title: ZooKeeper概览(一)
date: 2018-08-28 17:51:15
tags: ZooKeeper
categories: ZooKeeper
---
zk是一个分布式协调服务，是Google Chubby框架的开源实现

<!-- more -->
## 原理

### 特性/语义
1. 顺序性：客户端发起的更新操作会按照发送顺序在zk上执行
2. 原子性：zk操作要么成功，要么失败，不会有中间状态
3. 可靠性：客户端请求的操作一旦被接受，不会意外丢失，除非被覆盖
4. 最终一致性：写操作最终会对客户端可见(并非实时一致性)

### 核心组成
1. Leader：zk集群中只能同时有一个leader，
	它会发起并维护和各follower、observer之间的心跳
	所有的写操作必须由leader完成，leader写入本地日志后，再将写操作广播给follower、observer
2. Follower：一个zk集群可能有多个follower，它会响应leader的心跳
	follower可以直接处理客户端的读请求，并将写请求转发给leader处理
	在leader处理写请求的时候对请求进行投票()
3. Observer： 角色与follower类似，但无投票权

### watch机制
客户端所有对zk的读操作，都会有一个Watch，数据改变时，该watch机制被触发
特点：
> 主动推送：zk服务器**主动**将更新推送给客户端
> 一次性：数据变化时，只会被触发一次。如果客户端想要继续监听，必须重新注册一个新的watch
> 可见性：
> 顺序性：如果多个更新触发了watch机制，watch的顺序执行


### 会话


### 节点
zk的节点类型是一个文件系统的树形结构。每个节点存储Stat数据结构(version，cversion，aversion)，除此之外，还会记录节点本身的一些状态信息

1. 永久节点、临时节点

	> 永久节点：一旦创建，不会丢失，服务端重启后仍然存在。既可以包含数据，也可以包含子节点
	> 临时节点：客户端和服务端session会话结束，节点被删除。服务端重启后，节点消失
2. 顺序节点、非顺序性节点

	> 顺序节点：节点名在名称后带有10位10进制序号，多个客户端可以创建名称一样的节点，后面序号递增
	> 非顺序节点：客户端只能创建名称不同的节点。

#### 节点ACL权限
1. CREATE: 创建子节点的权限。
2. READ: 获取节点数据和子节点列表的权限。
3. WRITE：更新节点数据的权限。
4. DELETE: 删除子节点的权限。
5. ADMIN: 设置节点ACL的权限。

### 场景
1. 注册中心
2. 分布式锁
3. 分布式队列
4. 分布式协调/通知


## 单节点环境 ##

单节点的安装可以增加用户，而不是使用root用户启动。

1. 下载安装包、解压缩

		zookeeper-3.4.10.tar.gz

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


## zk在大型分布式系统中的应用
1. zk在Hadoop中的应
2. zk在HBase中的应用