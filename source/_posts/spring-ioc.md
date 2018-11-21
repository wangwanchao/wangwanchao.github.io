---
title: Spring的IOC原理分析
date: 2018-08-08 22:16:41
tags: java, Spring, ioc
categories: Spring
---

BeanFactory

ListableBeanFactory

HierarchicalBeanFactory

AutowireCapableBeanFactory

ApplicationContext


## 传统编程和IoC的对比 ##

传统编程：决定使用哪个具体的实现类的控制权在调用类本身，在编译阶段就确定了。

IoC模式：调用类只依赖接口，而不依赖具体的实现类，减少了耦合。控制权交给了容器，在运行的时候才由容器决定将具体的实现动态的“注入”到调用类的对象中。