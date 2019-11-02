---
title: SpringMVC时间传值问题
date: 2018-09-18 10:45:25
tags: Spring
categories: Spring
---
最近新入职公司，接手一个老项目，代码是多个人开发的，风格各异，中间就遇到时间传值问题，在VO层，有的传值Date，有的传值String


## 前台-->后台传值

1. 通过set转换不同格式
2. 在VO上使用注解，@DateTimeFormat(pattern = “yyyy-MM-dd HH:mm:ss”);@JsonFormat(pattern="yyyy-MM-dd HH:mm");
@Temporal(TemporalType.TIMESTAMP)
3. 创建BaseController类，所有的controller继承BaseController，BaseController中实现initBinder方法
4. 重写DateConverter类实现Converter<String, Date>接口，重写convert方法



## 后台-->前台传值

1. 在yml/xml中配置spring.jackson.date-format、spring.jackson.time-zone
2. 在VO上使用注解，@DateTimeFormat(pattern = “yyyy-MM-dd HH:mm:ss”);@JsonFormat(pattern="yyyy-MM-dd HH:mm");
@Temporal(TemporalType.TIMESTAMP)
