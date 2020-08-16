---
title: Spring--设计模式
date: 2018-08-12 21:22:53
tags: java
categories: Spring
---
Spring是一个非常值得学习的框架，一些优秀的设计模式值得分析。

<!-- more -->
## 简单工厂模式 ##


设计原则：要依赖抽象，不要依赖具体类

避免违反依赖倒置原则的建议：

> 变量不可以持有具体类的引用
> 
> 不要让类派生自具体类
> 
> 不要覆盖基类中已实现的方法

<!-- more -->

## 抽象工厂模式 ##


Spring的BeanFactory



## 建设者模式/生成器模式 ##


Spring中BeanDefinitionBuilder



## 代理模式 ##

Spring中ProxyFactoryBean


## 策略模式 ##

设计原则：针对接口编程，而不是针对实现编程

spring中MethodNameResolver + ParameterMethodNameResolver


## 模板方法模式 ##

Spring中AbstractApplicationCOntext.obtainFreshBeanFactory、refreshBeanFactory、getBeanFactory + GenericApplicationContext



## 策略、模板、状态3中设计模式的对比 ##


## 原型模式 ##

Spring中bean的作用域scope="prototype"

优点：

向客户隐藏制造新实例的复杂性

提供客户能够产生未知类型实例对象的选项

在某些环境下，复制对象比创建新对象更有效


## 观察者模式 ##

Spring中AbstractApplicationContext.addApplicationListener + ApplicationListener + ApplicationEventMulticaster



## 适配器模式 ##

Spring中AOP使用load-time-weaving针对AspectJ、CGLIB使用不同的逻辑



## 装饰者模式 ##


## 适配器模式、装饰者模式的区别 ##