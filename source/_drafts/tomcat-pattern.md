---
title: Tomcat--设计模式(四)
date: 2019-06-13 14:31:47
tags: tomcat
categpries: Servlet
---
设计模式总共有23种：
1. 
2. 
3. 

把需要变化的部分独立出来，不要和不变的混在一起
针对接口编程，而不是针对实现编程
多用组合，少用继承
开放-关闭原则：类应该对扩展开放，对修改关闭
依赖倒置原则：
最少知识原则：减少对象之间的交互

Tomcat中的设计模式一共有

## 责任链模式



## 适配器模式
目的：将一个接口转换成另一个接口
规律：如果遵守规范的话，一般Adapter结尾的类都是典型的适配器
核心类 Adapter、CoyoteAdapter、Connector

## 门面模式/外观模式
目的：让接口更简单
规律：如果遵守规范的话，一般Facade结尾的类都是典型的门面
核心类 ServletConfig、StandardWrapper、StandardWrapperFacade

## 监听模式/观察者模式

核心类 Lifecycle、LifecycleBase、LifecycleListener、LifecycleEvent、ContextConfig、EngineConfig、HostConfig

## 命令模式
我个人来看StandardHost的实现有命令模式的影子
核心类 Lifecycle、LifecycleBase、StandardHost


