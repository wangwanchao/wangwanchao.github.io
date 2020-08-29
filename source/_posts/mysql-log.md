---
title: MySQL中所有日志
date: 2019-11-02 21:57:40
tags: 日志
categpries: MySQL
---
mysql根据不同的用途划分了很多日志，系统崩溃日志、sql查询日志
慢查询日志、二进制日志(主从复制 binlog)、事务日志(undolog)、中继日志(relay log)

<!-- more -->
## error log
错误日志默认是开启的
用途：
1. 记录MySQL启动、关闭过程中的信息
2. 记录MySQL运行中错误
3. 记录事件调度。比如
配置：
```
log-error="filename.log"
```
查看命令：
```
SHOW VARIABLES LIKE 'log_error%';
```

## general log
查询日志默认是关闭的
用途：
1. 记录MySQL运行中所有的查询操作
配置：
```
log-output=FILE    # 输出类型
general-log=1      # 
general_log_file="filename.log"
```
查看命令：
```
SHOW VARIABLES LIKE 'general_log%';
```

## slow query log
慢查询日志默认是关闭的，记录超过`long_query_time`时长的查询。
用途：
1. 记录MySQL查询时间长的语句，方便排查性能问题

配置：
```
log-output=FILE
log_slow_queries=1    //MySQL 5.6将此参数修改为了slow_query_log
slow_query_log_file="filename.log"
long_query_time=10    //慢查的时长单位为秒，可以精确到小数点后6位(微秒)
```

查看命令：
```
SHOW VARIABLES LIKE 'slow_query_log%';
```

## bin log
默认关闭，常用于数据库崩溃恢复、主从复制
用途：
1. 记录MySQL运行过程中所有的DDL(修改数据库、数据表的语句)、DML(更新数据的语句)语句

刷盘策略：
sync_binlog：控制每次事务提交时，Binlog日志多久刷新到磁盘上，可取值：0或者n(N为正整数)。
  不同取值会影响MySQL的性能和异常crash后数据能恢复的程度。当sync_binlog=1时，MySQL每次事务提交都会将binlog_cache中的数据强制写入磁盘。

配置：
```
log-bin="filename-bin"
max_binlog_size={4096 .. 1073741824}  // 设置二进制文件最大值
expire_logs_days = 5       // 二进制文件在服务器保存天数
```

**注意：**某事务所产生的日志信息只能写入一个二进制日志文件，因此，实际上的二进制日志文件可能大于这个指定的上限。
**注意：**`expire_logs_days`参数只有在MySQL重启、切换二进制文件时生效

### 查看日志：
`bin log`的物理文件存储在`data`目录下，类如`mysql-bin.000001`。二进制日志在一下3种情况下会写入到新的文件：
1. MySQL重启
2. 二进制文件容量达到最大值
3. 手动执行命令`flush logs`

#### 1. 原生命令行查询

```
show binlog events;
show binlog events in 'mysql-bin.000002';
show binlog events in 'mysql-bin.000002'  from 107;
```

#### 2. 工具查询
```
mysqlbinlog ../data/mysql-bin.000003
```

### 日志刷盘时间


### 清除二进制日志
清除所有日志（不存在主从复制关系）
```
mysql> RESET MASTER;
```
清除指定日志之前的所有日志
```
mysql> PURGE MASTER LOGS TO 'mysql-bin.000003';
```
清除某一时间点前的所有日志
```
mysql> PURGE MASTER LOGS BEFORE '2015-01-01 00:00:00';
```
清除 n 天前的所有日志
```
mysql> PURGE MASTER LOGS BEFORE CURRENT_DATE - INTERVAL 10 DAY;
```
**注意：** 
1. 不要使用`rm`命令手动删除

## undolog/redolog
### redo log
记录数据页的物理修改，所以一般是物理介质文件，用来恢复提交后的物理数据页，且只能恢复到最后一次commit提交的位置。
redo log包括两部分：内存中的、磁盘上的，假如系统奔溃/宕机，将会导致内存中数据丢失，在事务提交时，将该事务所有事务日志写入磁盘

### undo log：记录事务信息，
配置：
```

```

刷盘策略：
1. innodb_flush_method: 控制innodb数据文件、日志文件的打开和刷盘的方式。
  > fsync
  > O_DIRECT(不经过系统内核buffer，直接从内存写入磁盘)。
2. innodb_flush_log_at_trx_commit: 控制每次事务提交时，redo log的写盘和落盘策略，即如何将buffer中的日志刷盘到磁盘中。可取值：0、1、2，默认值为1。
  > 当innodb_flush_log_at_trx_commit=1时，每次事务提交，会等待buffer中的日志写到log文件并刷新到磁盘上才返回成功。这种方式即使系统崩溃也不会丢失数据，但是IO性能较差。
  > =0时，事务提交时，并不会刷盘，而是每隔1s进行一次刷盘：先写入os buffer，再写入磁盘。系统奔溃会导致丢失这1s的数据。
  > =2时，事务提交时，将数据写入os buffer，然后每隔1s后将数据从os buffer写入磁盘

4. innodb_doublewrite：控制是否打开double writer功能，取值ON或者OFF。
  当Innodb的page size默认16K，磁盘单次写的page大小通常为4K或者远小于Innodb的page大小时，发生了系统断电/os crash ，刚好只有一部分写是成功的，则会遇到partial page write问题，从而可能导致crash后由于部分写失败的page影响数据的恢复。InnoDB为此提供了Double Writer技术来避免partial page write的发生。

### 单实例模式
MySQL单实例，Binlog关闭场景：
  innodb_flush_log_at_trx_commit=1，innodb_doublewrite=ON时，能够保证不论是MySQL Crash 还是OS Crash 或者是主机断电重启都不会丢失数据。
MySQL单实例，Binlog开启场景：
  默认innodb_support_xa=ON，开启binlog后事务提交流程会变成两阶段提交，这里的两阶段提交并不涉及分布式事务，mysql把它称之为内部xa事务。
  当innodb_flush_log_at_trx_commit=1，
  sync_binlog=1，innodb_doublewrite=ON, 
  innodb_support_xa=ON时，同样能够保证不论是MySQL Crash 还是OS Crash 或者是主机断电重启都不会丢失数据。

### 主从模式

## relay log
用于从数据库，从数据从主库申请复制数据时，从数据库先写relay log，然后再将数据从relay log写入数据库


## 日志写入顺序
1. 数据修改前，写入缓存中的redo log中
2. 修改记录数据
3. 事务提交指令时，向redo log中写入日志，同时一次性写入缓存中的bin log
4. 执行提交动作

## 拓展