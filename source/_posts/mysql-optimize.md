---
title: mysql优化
date: 2018-09-14 00:23:08
tags: mysql
categories: mysql
---
MySQL优化，把项目中常用的总结出来，形成方法论的东西。


<!-- more -->

## LIKE ##

	SELECT column FROM table WHERE field LIKE '%keyword%';

两边都有‘%’不走索引

	SELECT column FROM table WHERE field LIKE 'keyword%';

左边没有‘%’，才会走索引

可以通过explain执行计划查看，

优化替代方案：

1. LOCATE('substr', field, pos)
2. POSITION('substr' IN field)
3. INSTR(field, 'substr')
4. FIND_IN_SET('substr', field)


## IN、NOT IN ##


