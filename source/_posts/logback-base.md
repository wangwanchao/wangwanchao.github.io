---
title: logback配置文件
date: 2018-10-12 11:03:05
tags: logback
categories: logback
---
以前写过关于logging4j的配置，后来用logback，也没仔细分析过，在工作中遇到不同的用法，就来分析一下。

刚开始常用的是：其实这是最正规的写法

	logger.debug("massage:{}, code:{}", msg, code)
	
遇到过：这种写法会先拼接字符串，再判断debug级别

	logger.debug("massage:{}" + msg + "code:{}" + code)

还遇到过，包括一些开源项目源码中也存在：这种写法多了一层判断

	if(logger.isDebugEnabled()) { 
		logger.debug("massage:{}" + msg + "code:{}" + code)
	}


<!-- more -->

## Logback的体系结构

### logback标签

1. root 所有logger的祖先
2. logger 所有logger之间根据name命名构成父子关系
3. appender 日志可以打印到console、file、logstash，additivity标签用于控制日志打印
4. ContextName 
5. ContextListener
6. 变量 可以指定默认值 ${fileName:-logback.log}
	
	在配置文件中可以使用多种变量：
	
	> property 
		```<property scope="" name="" value="" />  <property file=".properties" /> <property resource=".properties" />```
	> 
	> 运行时定义变量 ```<define clas=""> </define>```
	>
	> 从JNDI获取变量 ```<insertFromJNDI env-entry-name="" as="" />```
7. include 一个配置文件中可以包含另一个配置文件 ```<include file=""/> <include resource=""/> <include url=""/>```
8. 配置全局信息 ```<configuration debug="true" scan="true" scanPeriod="30 seconds" packagingData="true">...</configuration>```

	> debug指定打印正常启动日志信息
	> 
	> scan、scanPeriod指定配置文件自动热加载
	> 
	> packagingData指定打印异常堆栈时打印jar包信息
	单位milliseconds、seconds、minutes、

### logback配置文件生命周期


## Logback的应用

Logback整合Spring boot，有两种配置方式：

### xml配置
```
<?xml version="1.0" encoding="UTF-8"?>
<configuration>

	<!-- 属性 -->
    <property name="PROJECT_NAME" value="lb-client"/>
    <property name="LOG_HOME" value="${PROJECT_NAME}"/>
    <property name="CONSOLE_LOG_PATTERN"
              value="%highlight(%d{HH:mm:ss.SSS} %-5level %X{traceId} -%X{requestStr} %msg%n)"/>
    
    <!-- appender组件：指定日志打印级别、格式、编码、目录、策略 -->
    <appender name="consoleLog" class="ch.qos.logback.core.ConsoleAppender">
        <layout class="ch.qos.logback.classic.PatternLayout">
            <pattern>
                ${CONSOLE_LOG_PATTERN}
            </pattern>
        </layout>
    </appender>
    
    <!-- 指定所有输出级别 -->
    <root level="info">
        <appender-ref ref="consoleLog"/>
        <appender-ref ref="fileInfoLog"/>
        <appender-ref ref="fileErrorLog"/>
    </root>
    
    <!-- 单独指定包日志打印级别 -->
    <logger name="com.liyan" level="DEBUG">    
        <appender-ref ref="demolog" />    
    </logger>   

</configuration>

```

### yml配置

```	
logging:
    file:   # 日志文件,绝对路径或相对路径
    #path:   # 保存日志文件目录路径 file和path两者二选一
    config: # 日志配置文件,Spring Boot默认使用classpath路径下的日志配置文件,如:logback.xml
    level:  # 日志级别
        root: info
        org.springframework.web: DEBUG # 配置spring web日志级别，类似于logger标签
        com.xxx.mapper: DEBUG
    pattern:
        console: %d{yyyy/MM/dd-HH:mm:ss} [%thread] %-5level %logger- %msg%n
        file: %d{yyyy/MM/dd-HH:mm} [%thread] %-5level %logger- %msg%n
```














