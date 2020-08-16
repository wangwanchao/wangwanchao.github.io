---
title: Tomcat启动流程(二)
date: 2019-06-15 22:54:00
tags: tomcat
categpries: Servlet
---
tomcat启动流程

<!-- more -->
## Bootstrap类启动
tomcat支持多种方式启动，最常用、最稳定的是基于`server.xml`方式的启动，实现类Bootstrap。

## Tomcat类启动
Tomcat类用于内嵌tomcat的最小化启动

条件:
 * 所有的class、servlet文件都在classpath路径下
 * 需要临时的工作目录
 * 不需要配置文件，`web.xml`文件是可选的，Tomcat类提供了设置方法

提供了各种配置servlet和webapp的方法，默认创建一个内存安全域。如果需要更复杂的安全设置，可以自己实现一个继承Tomcat的子类

提供了一系列方法(例如addWebapp)用来配置`web context`，然后创建并添加到`Host`，并不使用全局的web.xml，同时添加一个`lifecycle`监听器，监听器添加默认的Servlet、JSP文件。

在更复杂的场景，可能更喜欢使用API来创建Context。如果模拟`addWebapp`方法的行为，则需要调用两个方法 `getDefaultWebXmlListener()`和`noDefaultWebXmlPath()`。

 `getDefaultWebXmlListener()`返回一个LifecycleListener监听器，如果添加了这个监听器，则必须禁止使用全局的`web.xml`。

 `noDefaultWebXmlPath()`返回一个虚假路径阻止ContextConfig配置全局`web.xml`。

