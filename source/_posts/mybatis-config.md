---
title: MyBatis配置文件解析
date: 2018-09-30 18:54:41
tags: mybatis
categories: mybatis
---
springboot整合mybatis有不同的方式：

## mybatis -- spring-boot-starter

通过properties/yml配置

```
mybatis.config：mybatis-config.xml配置文件的路径
mybatis.typeHandlersPackage：扫描typeHandlers的包
mybatis.checkConfigLocation：检查配置文件是否存在
mybatis.executorType：设置执行模式（SIMPLE, REUSE, BATCH），默认为SIMPLE
mybatis.mapper-locations=classpath:/mybatis/*Mapper.xml //2
mybatis.type-aliases-package=tk.mapper.model 

```

## mybatis -- spring

创建@Configuration MyBatisConfig配置类，





### 属性

1. configLocation

	指定mybatis-config核心配置文件的路径
2. objectFactory  DefaultObjectFactory
3. objectWrapperFactory DefaultObjectWrapperFactory
4. vfs

	用来读取服务器相关资源，并加载相关的类
5. typeAliasesPackage 

	给整个包起一个别名，
6. typeAliases

	设置别名，
7. Plugins

	插件，用于sql执行过程中对方法对拦截调用。常见的几种插件：
	· Executor (update, query, flushStatements, commit, rollback, getTransaction, close, isClosed)

	· ParameterHandler (getParameterObject, setParameters)
	
	· ResultSetHandler (handleResultSets, handleOutputParameters)
	
	· StatementHandler (prepare, parameterize, batch, update, query)
8. typeHandlersPackage、typeHandlers

	类型转换器，用于Javabean和数据库类型之间的转换
9. databaseIdProvider

	用于多数据源切换
10. Cache

	扩展MyBatis Cache接口，自定义缓存
11. xmlConfigBuilder

	
12. transactionFactory

	没有自定义事务时，默认使用Spring的事务
13. mapperLocations

	Mapper.xml文件的扫描路径
