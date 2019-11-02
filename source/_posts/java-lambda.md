---
title: java中lambda表达式原理
date: 2018-10-11 13:51:01
tags: java
categpries: Java
---
函数式编程
<!-- more -->
## 原理
### 底层原理
1. lambda又称为闭包/匿名函数
2. lambda方法在编译器内部被翻译成私有方法(lambda$0/1/2/3)，并派发invokedynamic字节码指令进行调用。这个指令会调用bootstrap方法。

		javap -p xxx.class
		javap -c -v xxx.class	
3. bootstrap实际上是调用了LambdaMetafactory.metafactory静态方法，该方法返回CallSite(调用栈点)，栈包含了最终调用的方法。bootstrap方法只会调用一次。

**注意：**lambda只能引用final或final局部变量，也就是说不能在lambda内部修改定义在域外的变量。
### 中间操作
有状态操作
无状态操作

### 终止操作
非短路操作
短路操作

### 懒加载机制

## 应用
### 规则
1. 定义一个接口，该接口中只能有一个方法
2. 接口上添加'@FunctionalInterface'注解

### jdk1.8自带的接口函数
|接口|输入参数|返回类型|功能|
|-|:-:|:-:|:-:|
|Predicate<T>		| T | boolean | |
|Consumer<T>		| T | -		|	|	
|Function<T,R>	| T | R		|	|
|Supplier<T>		| - | T		|	|
|UnaryOperator<T>| T | T		|	|
|BiFunction<T,U,R>| (T,U) | R	|	|	
|BinaryOperator<T>| (T,T) | T |	|
