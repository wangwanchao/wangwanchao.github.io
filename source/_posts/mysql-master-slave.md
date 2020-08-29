---
title: MySQL主从复制
date: 2018-08-08 22:17:15
tags: 主从
categories: MySQL
---
MySQL的集群(主从模式)主要解决单点故障问题，但是主从之间无法保证严格的'数据一致性'

<!-- more -->
## 主从工作原理 ##
主从模式又分为单主单从、单注多从、级联(从节点下还有从节点)
1. 主库把数据更新记录到二进制日志
2. 从库将主库的日志复制到自己的中继日志

	> 备库启动I/O线程，和主库建立一个客户端连接
	> 
	> 主库启动特殊的转储线程，读取主库上二进制日志中的事件
	> 
	> 备库I/O线程将接收到的事件记录到中继日志

3. 备库读取中继日志的事件，数据写入从数据库

从库sql线程从中继日志读取事件、执行事件。

主从复制，又有不同的模式：基于语句的复制、基于行的复制
### 基于语句的复制 ###
主库会记录所有数据更新的sql，当备库读取重放这些事件时，实际上是把所有执行过的sql语句执行一遍。

优点：

缺点：

### 基于行的复制 ###
将实际的数据记录在二进制日志中。

优点：

缺点：

### 复制模式
#### 异步复制

#### 半同步复制
1. rpl_semi_sync_master_wait_point=WAIT_AFTER_COMMIT，主库先完成commit提交后，再同步至从库，等待从库的ACK.

问题：如果在同步之前，主库发生崩溃 ，会出现事务数据丢失，导致数据不一致。
2. rpl_semi_sync_master_wait_point=WAIT_AFTER_SYNC，
问题：

**注意：**主库在等待从库ACK超时，会降级为异步复制
#### 同步复制

### 数据不一致
由于服务器负载、网络拥堵等问题，Master和Slave之间数据一致性没有保证。

解决方案：
1. 在master insert/update操作后强制sleep几秒
2. 把更新的数据保存在内存/或者保存在缓存中(例如redis)，当写操作完成后，读数据直接从缓存中读取。
3. 使用MySQL Proxy代理实现。原理：在master、slave各维护一张count_table表，当master执行insert/delete/update操作时，触发器触发count_table表字段自增。当client请求proxy服务器时，proxy先查询master+slave的count_table表，如果一致，则查询slave，否则查询master

补充：安装MySQL Proxy

#### 1032、1062错误
1032：从库上不存在记录
1062：从库上存在和主库要插入的重复的数据
从库可以通过修改参数解决这些错误：
1. sql_slave_skip_counter=N
跳过1个事务，一个事务包括N个event，一个sql语句可能对于多个event
2. slave-skip-errors=1062
跳过错误
3. slave_exec_mode='IDEMPOTENT'
`slave_exec_mode`分为两种模式：
> STRICT：会出现以上的错误
> IDEMPOTENT：依赖于'基于行复制'的bin log模式，在'基于语句复制'模式下不起作用，一般用于多主复制、NDB Cluster情况下

## 环境搭建 ##

### 主库 ###
执行步骤：
1. 修改配置文件
```
	vi /etc/my.cnf
```
配置参数
```
	log_bin=mysql-bin  
	server-id=1 
	replay_log=/var/lib/mysql/mysql-replay-bin
	log_slave_updates=1
	read_only=1
	innodb_flush_log_at_trx_commit=1 
	sync_binlog=1
```
启动MySQL
```	
	systemctl restart mysqld;
```
**注意：** log_bin一定要开启，也可以是'log-bin',如果不开启可能会报错：

ERROR 2006 (HY000): MySQL server has gone away
No connection. Trying to reconnect...
Connection id:    3
Current database: *** NONE ***

Empty set (0.00 sec)

#### 参数解释 ####

2、创建一个供局域网内连接的用户(有的提到要加锁)

	grant replication slave on *.* to 'admin'@'192.168.117.%' identified by 'xxxxxx';

	flush privileges;

**注意：** on后面是'*.*',否则可能会报错：

ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'to 'admin-m'@'192.168.117.%' identified by 'admin234'' at line 1

3. 查看主库
```
	mysql -uroot -p
	show master status \G;
```	
### 从库 ###
操作步骤：
1. 修改配置(有的提到修改/var/lib/mysql/auto.cnf文件)
```
	vi /etc/my.cnf
```
配置参数：
```
	server_id=22
	relay_log=relay-log-bin
	skip_slave_start
	read_only
	relay_log_index=slave-relay-bin.index
```
2. 连接到主库
```
	change master to master_host='192.168.117.135',master_port=3306,master_user='admin',master_password='xxxxx',master_log_file='mysql-bin.000003',master_log_pos=154;
```
参数解释：

3. 启动从库，查看是否启动成功
```
	start slave;
	show slave status \G;
```
如果Slave_IO_Running: YES Slave_SQL_Running: Yes,则表明启动成功。

参数Last_IO_Errno: 1236 Last_IO_Error显示失败的原因。

错误1:中间重启从库mysql,启动后直接start slave;

报错：ERROR 1872 (HY000): Slave failed to initialize relay log info structure from the repository

解决：
```
	reset slave;
	change master .....;
	start slave;
```
启动成功；

## MySQL读写分离 ##
从库配置参数：
```
--skip-innodb
--skip-bdb
--low-priority-updates
--delay-key-write=ALL
```

