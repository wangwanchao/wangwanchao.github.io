---
title: PostgreSQL基础环境搭建
date: 2018-09-04 23:05:48
tags: postgresql
categories: postgresql
---
写这一篇博客的意义就是让自己保持经常写作的习惯，否则超过三天不写，就会一直拖延、逃避，不想当架构师的码农不是好程序员。

环境: CentOS7

<!-- more -->

## 安装 ##

	yum install postgresql-server

开机自启动

	postgresql-setup initdb
	systemctl enable postgresql.service
	systemctl start postgresql.service

## 创建数据库

	CREATE USER postgres WITH PASSWORD '';
	DROP DATABASE postgres;
	CREATE DATABASE postgres OWNER postgres;
	GRANT ALL PRIVILEGES ON DATABASE postgres to postgres;
	ALTER ROLE postgres CREATEDB;


## 登录 ##


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

## 操作 ##

创建数据库、创建表、数据操作都符合SQL语法
