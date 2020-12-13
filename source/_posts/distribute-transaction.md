---
title: 分布式事务
date: 2020-12-13 13:24:28
tags:
categpries: Distribute
---
从MySQL事务，到Spring事务，再到分布式事，是一个渐进的过程。不论你是在拧螺丝还是造火箭，都应该对一些热点的技术有一些了解，这些技术虽然不一定当下就用到，但是在遇到一些问题时，可以给你不一样的思路。

<!-- more -->

## 分布式事务
`MySQL InnoDB`存储引擎支持XA事务，JTA(Java Transaction Manager)是分布式事务的一种基于XA协议的实现方式，用来解决跨数据库的事务操作。典型的实现框架`jotm`、`Atomikos`，实现原理就是基于XA协议