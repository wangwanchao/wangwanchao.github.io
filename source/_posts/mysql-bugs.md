---
title: mysql踩坑经历
date: 2018-10-12 18:47:57
tags: MySQL
categories: MySQL
---
mysql使用中还是会有各种各样的坑，在实际使用中就遇到几个小问题，

<!-- more -->

1. tinyint(1)的问题

	tinyint(1)字段中数值大于1时，都返回true

	原因：
	
	MySQL没有bool的概念，tinyint(1)隐式作为bool类型，0为false，非0为true。
	
	解决方案：
	
	> 在URL连接路径中添加 'Treat Tiny As Boolean=false' 
	> 在sql语句中 tinyint字段*1
	> 使用tinyint(4)或者int类型

2. 时间大于2037年的问题

	mysql时间不支持大于2037年的后时间，查询返回0.
	
	
3. 北京时间'1970-01-01 08:00:00'的问题

	当字段为'1970-01-01 08:00:00'的时候报错
	com.mysql.jdbc.MysqlDataTruncation: Data truncation: Incorrect datetime value: '1970-01-01 08:00:00' for column
	
	原因：
	
	mysql时间的支持范围是'1970-01-01 08:00:01'，	而传入的字段时区是GMT+8，转为'1970-01-01 08:00:00'，不在支持范围内，所以抛异常


