---
title: java中paralelStream方法的坑
date: 2018-12-24 11:26:40
tags: Java
categpries: Java
---
今天在项目开发中使用parallelStream遍历ArrayList，发现数据有时候多有时候少，有时候出现'null'的对象，在本地甚至出现'Exception in thread "main" java.lang.ArrayIndexOutOfBoundsException: 6246
'

<!-- more -->

