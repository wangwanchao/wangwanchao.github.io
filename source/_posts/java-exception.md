---
title: java中的错误与异常
date: 2018-09-21 11:47:10
tags: java
categories: java
---
Web项目中的异常处理，什么时候该处理异常，什么抛出异常，总感觉没有形成一套理论的形式，不同的团队遇到不同的处理，但是大致流程一致。

## 错误分类

Error:理论上也属于非检查异常。例如：系统崩溃、虚拟机错误、内存溢出、方法调用栈溢出。这样的错误一般无法恢复和预防，只能通过重启应用解决

<!-- more -->

![](http://pciqklc7l.bkt.clouddn.com/Error.png)


## 异常分类

java中分两类：

1. 检查异常：必须进行处理
	
	> 继续抛出
	>
	> try-catch捕获

2. 非检查异常(RuntimeException 运行时异常)：可以不处理编译通过，一般是由于程序的错误导致的，例如：ArithmeticException、错误的类型转换、数组越界、空指针
	
	> 捕获
	>
	> 继续抛出
	>
	> 不处理
	

业务开发中的异常分类：

1. 系统异常

	自定义的、可预知的异常。例如：用户密码错误、参数错误
	
	一般只需要记录错误的描述信息，例如定义
	
2. 业务异常
	
	系统运行时异常。例如：数据库连接异常、IO失败、空指针
	
	一般需要生成完整的调用栈追踪信息
	
### throws

当不知道如何处理异常时，可以通过throws抛给调用者或者JVM。

### throw

使用throw抛出异常时，抛出的不是一个类，而是一个对象。

> 如果抛出的异常是一个Checked异常，则使用try-catch捕获、或者放在一个throws方法内。
> 如果抛出的是RuntimeException，则可以使用try-catch捕获、或者不做任何处理
> 

### 自定义异常
异常类继承关系图：

![](http://pciqklc7l.bkt.clouddn.com/Exception.png)

可以看到自定义异常一定是Throwable的子类，

1. 若是检查异常就要继承Exception类
2. 若是运行时异常，就继承Runtime
Exception

### 异常链：

捕获一个异常，然后接着抛出另一个异常，并把原始信息保存下来的链式处理。

应用场景：

### try-catch-finally-return

finally代码块一定会在try/catch代码块return之前执行，如果finally有return，则提前执行return，try/catch中的return不再执行。

## 异常处理

1. 不用过度使用异常：可预测的错误应该通过代码逻辑处理，不确定的、运行时异常才抛出异常
2. 不用使用try包含太多的代码逻辑，
3. 避免使用Catch All语句：Catch All即catch(Throwable t)，扩大异常的范围不利于排查错误
4. 不要忽略已捕获的异常：对于捕获的异常应该进行处理提高代码的健壮性，而不是只打印跟踪栈信息。

