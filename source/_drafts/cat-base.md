---
title: Cat实现监控埋点
date: 2018-10-19 10:39:36
tags: Cat
categories: Cat
---
项目中打算使用Cat做一些监控，在搭建的过程中，踩了一些坑。浪费了很多时间，现在回顾一下为什么浪费了那么多时间。

首先我不知道为什么官方文档要那么写，写的乱七八糟，初学者很不利于理解。而且把单机和集群模式放在一起讲，里面很多的东西也不是很懂，就导致浪费很多时间。

<!-- more -->

[Cat源码](https://github.com/dianping/cat/)

[文档](https://github.com/dianping/cat/blob/master/cat-doc/posts/ch4-server/README.md)

## 原理
其实所有的监控无非就是分为服务端、客户端。服务端作为监控数据的消费者，暴露一些端口给客户端，客户端发送日志数据到服务端。

## 单机部署

### 服务端Cat部署
1. 创建数据库，存储监控数据就需要数据库cat，script/CatApplication.sql创建数据表
2. 配置数据源，cat的数据源统一从'/data/appdatas/cat/'中读取，所以要创建文件'datasources.xml'，授权
	
		vi datasources.xml
		chown -R 777 /data/
		
	```
	<?xml version="1.0" encoding="utf-8"?>

	<data-sources>
		<data-source id="cat">
			<maximum-pool-size>3</maximum-pool-size>
			<connection-timeout>1s</connection-timeout>
			<idle-timeout>10m</idle-timeout>
			<statement-cache-size>1000</statement-cache-size>
			<properties>
				<driver>com.mysql.jdbc.Driver</driver>
				<url><![CDATA[jdbc:mysql://127.0.0.1:3306/cat]]></url>  <!-- 请替换为真实数据库URL及Port  -->
				<user>root</user>  <!-- 请替换为真实数据库用户名  -->
				<password>root</password>  <!-- 请替换为真实数据库密码  -->
				<connectionProperties><![CDATA[useUnicode=true&characterEncoding=UTF-8&autoReconnect=true&socketTimeout=120000]]></connectionProperties>
			</properties>
		</data-source>
	</data-sources>
```

	**注意：cat不支持mysql8.0，我在这里踩了大坑**

3. 配置服务器信息，创建'server.xml'，授权

		vi server.xml
		chown -R 777 /data/
		
	```
	
	```
		
4. 	配置tomcat，启动cat.war

	[cat.war](http://cat.meituan.com/nexus/service/local/repositories/releases/content/com/dianping/cat/cat-home/3.0.0/cat-home-3.0.0.war)

	cat需要在tomcat/webapps下启动。

5. 查看日志，检查是否启动成功，可以用来排查异常

		cat /data/applogs/cat/cat_20181129.log
		
6. 浏览器WebUI，

默认是 http://localhost:8080/cat

账号密码 admin/admin	

### 客户端cat-client整合SpringBoot

客户端一般用在web项目中，处理一些埋点信息。

1. 引用cat-client依赖包，这些包网上不好找，但是在服务端部署中，war包里包含最新的各种依赖包，可以从解压后的目录下复制
	
	```
	<dependency>
            <groupId>com.dianping.cat</groupId>
            <artifactId>cat-client</artifactId>
            <version>3.0.0</version>
        </dependency>

        <dependency>
            <groupId>com.dianping.cat</groupId>
            <artifactId>cat-core</artifactId>
            <version>3.0.0</version>
        </dependency>
	```

2. 配置过滤器，

	```
	@Configuration
	public class CatConfiguration {
	
	    @Bean
	    public FilterRegistrationBean catFilter() {
	        FilterRegistrationBean registration = new FilterRegistrationBean();
	        CatFilter filter = new CatFilter();
	        registration.setFilter(filter);
	        registration.addUrlPatterns("/*");
	        //   registration.addInitParameter("exclusions","*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*");
	        registration.setName("cat-filter");
	        registration.setOrder(2);
	        return registration;
	    }
	}
	```
	
3. 配置项目名称，一定是在src/main/resources/META-INF中配置app.properties

		app.name=cat-test

**注意：这一步配置错误，会导致日志报错，或者即使cat可以监控到，request请求也无法正常监控**

4. 配置'client.xml'，授权，同样是在'/data/appdatas/cat/'目录下。

		vi client.xml
		chmod -R 777 /data/

	```
	<?xml version="1.0" encoding="utf-8"?>

	<config mode="client" xmlns:xsi="http://www.w3.org/2001/XMLSchema" xsi:noNamespaceSchemaLocation="config.xsd">
	    <servers>
	        <!-- ip:cat指服务器的地址，如果在不同的主机，可以配置远程IP -->
	        <server ip="127.0.0.1" port="2280" http-port="8080" />
	        <!-- If under production environment, put actual server address as list. -->
	        <!-- 
	            <server ip="192.168.7.71" port="2280" /> 
	            <server ip="192.168.7.72" port="2280" /> 
	        -->
	    </servers>
	</config>
```

5. 查看日志，检查是否成功

	客户端的日志同样生成在'/data/applogs/cat/'下，
	
		cat cat_client_20181129.log
		
6. postman模拟请求，即可在cat服务器上看到

开始显示'全部''常用'，点击'常用'即可看到app.name命名的监控

![](http://impwang.oss-cn-beijing.aliyuncs.com/cat0.png)

![](http://impwang.oss-cn-beijing.aliyuncs.com/cat.png)

