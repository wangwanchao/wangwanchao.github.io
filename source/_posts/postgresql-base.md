---
title: PostgreSQL基础环境搭建
date: 2018-09-04 23:05:48
tags: postgresql
categories: PostgreSQL
---
写这一篇博客的意义就是让自己保持经常写作的习惯，否则超过三天不写，就会一直拖延、逃避，不想当架构师的码农不是好程序员。

<!-- more -->

## CentOS7 ##
### yum默认安装(可能导致安装版本过低)

	yum install postgresql-server postgresql

(推荐官网安装)

[官网](https://www.postgresql.org/download/linux/redhat/)

官方安装报错：

yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
已加载插件：fastestmirror
无法打开 https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm ，跳过。
错误：无须任何处理

更新yum仓库：

	rpm -Uvh https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
	
	yum install -y postgresql10-server postgresql10

也可以手动下载安装：
[下载地址](https://yum.postgresql.org/rpmchart.php)
### 初始化

	postgresql-setup initdb

### 开机自启动

	systemctl enable postgresql.service
	systemctl start postgresql.service

### 创建数据库

	CREATE USER postgres WITH PASSWORD '';
	DROP DATABASE postgres;
	CREATE DATABASE postgres OWNER postgres;
	GRANT ALL PRIVILEGES ON DATABASE postgres to postgres;
	ALTER ROLE postgres CREATEDB;


### 登录
切换用户

	su - postgres

登录

	psql -U [user] -d [database] -h [host] -p [password]
	
1. 默认登陆
	
		psql
	
2.	用户名密码登录

		psql -U postgres -d postgres
		
常用REPL命令

	退出 Ctrl + D;
	\password：设置当前登录用户的密码
	\h：查看SQL命令的解释，比如\h select。
	\?：查看psql命令列表。
	\l：列出所有数据库。
	\c [database_name]：连接其他数据库。
	\d：列出当前数据库的所有表格。
	\d [table_name]：列出某一张表格的结构。
	\du：列出所有用户。
	\e：打开文本编辑器。
	\conninfo：列出当前数据库和连接的信息。
	\password [user]: 修改用户密码
	\q：退出

### 操作

创建数据库、创建表、数据操作都符合SQL语法

## Mac
### 安装
默认安装目录在`/usr/local/Cellar`

	brew install postgresql

查看安装版本

	psql --version 
	pg_ctl -V
	
	// 进入数据库
	psql -d postgres

### 初始化
初始化会在`/usr/local/var`生成postgres目录

	initdb /usr/local/var/postgres -E utf8

### 设置代理
在目录`~/Library/LaunchAgents`设置代理


### 启动

	// 后台启动postgresql
	brew services start postgresql
	// 前台启动
	postgres -D /usr/local/var/postgres
	// 停止postgresql
	brew services stop postgresql
	// 重启postgresql
	brew services restart postgresql

### 查看启动成功

	ps -ef |grep postgres
	
### 命令行操作数据库

	psql
	psql -h localhost
	
	// 使用超级用户登录
	psql -d postgres
### 开机自启动

设置开机自启动

	// 建立软连接
	ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents 
	// 加载
	launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
	
取消开机自启动
	
	// 卸载
	launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
	// 移除
	rm -rf ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
### 卸载

	brew uninstall postgres


## 错误
### mac下命令行连接错误

	psql: could not connect to server: No such file or directory
	Is the server running locally and accepting
	connections on Unix domain socket "/tmp/.s.PGSQL.5432"?
	
### Navicat客户端连接错误

	FATAL:  role "postgres" does not exist

### 命令行连接错误
1. psql: FATAL:  Peer authentication failed for user "kong"

2. psql: FATAL:  Ident authentication failed for user "kong"
解决： 修改配置文件

```
vi /var/lib/pgsql/data/pg_hba.conf 	
systemctl reload postgresql
```
