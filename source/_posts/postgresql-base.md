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

## 登录 ##

切换用户

	su - postgres

登录

	psql

退出 Ctrl + D;

## 操作 ##

创建数据库、创建表、数据操作都符合SQL语法
