---
title: java中lambda表达式原理
date: 2018-10-11 13:51:01
tags: java
categories: java
---

1. lambda又称为闭包/匿名函数
2. lambda方法在编译器内部被翻译成私有方法，并派发invokedynamic字节码指令进行调用。

		javap -p xxx.class
		javap -c -v xxx.class
	
3. lambda只能引用final或final局部变量，也就是说不能在lambda内部修改定义在域外的变量。

