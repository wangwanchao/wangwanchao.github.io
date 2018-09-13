---
title: mysql主从复制
date: 2018-08-08 22:17:15
tags: mysql,
categories: mysql
---
## 主要解决的问题： ##

数据分布

负载均衡

备份

高可用性和故障切换

升级测试

<!-- more -->

## 工作原理 ##

1、主库把数据更新记录到二进制日志

2、备库将主库的日志复制到自己的中继日志

> 备库启动I/O线程，和主库建立一个客户端连接
> 
> 主库启动特殊的转储线程，读取主库上二进制日志中的事件
> 
> 备库I/O线程将接收到的事件记录到中继日志

3、备库读取中继日志的事件，写入数据

备库sql线程从中继日志读取事件、执行事件

### 基于语句的复制 ###

主库会记录所有数据更新的sql，当备库读取重放这些事件时，实际上是把所有执行过的sql语句执行一遍。

优点：

缺点：

### 基于行的复制 ###

将实际的数据记录在二进制日志中。

优点：

缺点：

## 环境搭建 ##

### 主库 ###

1、修改配置文件

	vi /etc/my.cnf

配置参数

	log_bin=mysql-bin  
	server-id=1 
	replay_log=/var/lib/mysql/mysql-replay-bin
	log_slave_updates=1
	read_only=1
	innodb_flush_log_at_trx_commit=1 
	sync_binlog=1

启动MySQL
	
	systemctl restart mysqld;

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

3、查看主库

	mysql -uroot -p
	show master status \G;
	
### 从库 ###

1、修改配置(有的提到修改/var/lib/mysql/auto.cnf文件)

	vi /etc/my.cnf

配置参数：

	server_id=22
	relay_log=relay-log-bin
	skip_slave_start
	read_only
	relay_log_index=slave-relay-bin.index

2、连接到主库

	change master to master_host='192.168.117.135',master_port=3306,master_user='admin',master_password='xxxxx',master_log_file='mysql-bin.000003',master_log_pos=154;

参数解释：

3、启动从库，查看是否启动成功

	start slave;

	show slave status \G;


如果Slave_IO_Running: YES Slave_SQL_Running: Yes,则表明启动成功。

参数Last_IO_Errno: 1236 Last_IO_Error显示失败的原因。

错误1:中间重启从库mysql,启动后直接start slave;

报错：ERROR 1872 (HY000): Slave failed to initialize relay log info structure from the repository

解决：

	reset slave;

	change master .....;

	start slave;

启动成功；

