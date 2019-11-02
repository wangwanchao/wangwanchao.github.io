---
title: SpringBoot配置文件加载bug
date: 2019-08-14 14:16:34
tags:
categpries: SpringBoot
---
IDEA环境以前曾经遇到过，通过添加依赖包可以解决，而且，创建的maven模块有时候正常，有时候出现该问题，问题的根本还是不太懂

<!--more-->
## 问题描述

### 未加载前
bootstrap文件为yml格式，但是并未识别为配置文件

![](https://impwang.oss-cn-beijing.aliyuncs.com/spring/springboot-bootstrap.png)

查看模块设置`Open Module Settings` - Module，发现并未自动检测，没有找到任何手动添加设置
![](https://impwang.oss-cn-beijing.aliyuncs.com/spring/springboot-bootstrap2.png)

### 加载后
添加spring-cloud-context，bootstrap文件可以被正常检测
![](https://impwang.oss-cn-beijing.aliyuncs.com/spring/springboot-bootstrap3.png)

迷
![](https://impwang.oss-cn-beijing.aliyuncs.com/spring/springboot-bootstrap4.png)

## 加载原理