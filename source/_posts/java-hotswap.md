---
title: java热部署技术
date: 2018-10-14 12:38:41
tags: java
categories: java
---


## 热部署的应用 ##

### SpringLoaded ###

1. Maven添加依赖的方式启动

	<plugin>
	    <groupId>org.springframework.boot</groupId>
	    <artifactId>spring-boot-maven-plugin</artifactId>
	    <dependencies>
	        <dependency>
	        <groupId>org.springframework</groupId>
	        <artifactId>springloaded</artifactId>
	        <version>1.2.6.RELEASE</version>
	        </dependency>
	    </dependencies>
	</plugin>

运行:

	mvn spring-boot:run 或者点击IDEA右侧栏相应命令

2. 下载springloaded jar包，通过指定VM options参数运行

		-javaagent:C:\Users\tengj\.m2\repository\org\springframework\springloaded\1.2.6.RELEASE\springloaded-1.2.6.RELEASE.jar -noverify

注意：

在Spring Boot中，模板引擎页面默认开启缓存，修改页可能无法热加载，需要通过设置模板引擎的缓存。

	spring.freemarker.cache=false
	spring.thymeleaf.cache=false
	spring.velocity.cache=false

热部署失效的情景：

> 对一些注解的修改
> application.properties的修改
> log4j的配置文件的修改。

*为什么会失效，留下一个疑问？*


### spring-boot-devtools ###

	<dependencies>
	    <dependency>
	        <groupId>org.springframework.boot</groupId>
	        <artifactId>spring-boot-devtools</artifactId>
	        <optional>true</optional>
	    </dependency>
	</dependencies>

devtools的特性：

1. 默认关闭模板引擎缓存
2. 灵活的自动重启机制

	> 排除静态资源文件
	> 关闭自动重启
	> 指定修改固定文件后触发重启
	> 自定义自启动类加载器

详细可以查看[官方文档](https://howtodoinjava.com/spring-boot2/developer-tools-module-tutorial/)