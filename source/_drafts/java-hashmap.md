---
title: HashMap中hash冲突分析
tags: Java
categories: Java
---


### 数字关键字散列函数 ###


### 字符关键字散列函数 ###

1. ASCII码加和法


### 冲突处理 ###

1. 开放地址法：
	
	> 线性探测、 \\(E = mc^2\\) 
	> 
	> 平方探测、
	> 双散列

$$x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}$$

$$h_i$$
2. 链地址法(分离链接法)：

When \\( a \ne 0 \\), there are two solutions to \\(ax^2 + bx + c = 0\\) and they are: 
$$ x = {-b \pm \sqrt{b^2-4ac} \over 2a} $$

## HashMap ##

hashmap中采用链地址法，链表是单向链表。

**JDK1.8改写了很多东西**

### 负载因子 ###

1. 增大负载因子，可以减少hash表占用内存空间，但会增加查询数据的时间开销
2. 减少负载因子，会提高数据查询的性能，但会增加hash表所占用的内存空间