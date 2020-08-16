---
title: java动态代理
date: 2018-08-30 23:51:41
tags: java
categories: java
---

代理模式可以将具体的实现与调用方法解耦，将具体的实现隐藏在内部。升华就是由实践上升到理论的过程，要能把所有的东西讲明白。

## 静态代理 ##

在编译阶段将接口、实现类、代理类全部编译完成。

<!-- more -->

## 动态代理 ##

在程序运行期间根据需要动态的创建代理类及其实例。

### JDK动态代理 ###

利用反射机制生成一个实现代理接口的匿名类，在调用具体方法前调用InvokeHandler来处理;
只能对实现了接口的类生成代理，而不能针对类

JDK代理要求：

	实现InvocationHandler接口
	使用Proxy.newProxyInstance产生代理对象
	被代理的对象必须实现接口，如果该对象没有实现接口则不能生成代理对象

案例：


### CGLIB动态代理 ###


### ASM字节码 ###


### Javassist库 ###


#### 为什么需要动态代理？ ####

1. 需要动态的增强具体业务的逻辑，比如AOP
2. 业务增强逻辑相同，可以统一处理。例如log管理、权限认证
3. 可以灵活地控制被代理类，很好的解耦


## 代理在Spring中的应用 ##

JDK代理和CGLIB代理在Spring中的应用：

> 如果对象实现了接口，则默认采用JDK代理实现AOP
> 
> 如果对象没有实现接口，则必须采用CGLIB代理实现AOP

强制使用CGLIB实现AOP：

	添加CGLIB库，cglib/*.jar
	在spring配置文件中加入<aop:aspectj-autoproxy proxy-target-class="true"/>