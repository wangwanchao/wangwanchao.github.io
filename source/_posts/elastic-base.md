---
title: Elasticsearch搜索
date: 2018-08-29 12:35:37
tags: Elasticsearch
categories: Elasticsearch
---
去年接触过一些ELK环境的搭建，用来处理日志信息，涉及到的东西很多，回头慢慢整理，今天先回顾一下ES

## 环境搭建 ##

依赖于JDK，对jdk版本、内存有要求，否则会启动失败

### tar.gz安装 ###

需要创建用户组、用户、非root用户启动

### rpm安装 ###

1. 直接安装，默认创建用户组

		rpm -ivh elasticsearch-6.4.0.rpm
	
	提示

		正在升级/安装...
		   1:elasticsearch-0:6.4.0-1          ################################# [100%]
		### NOT starting on installation, please execute the following statements to configure elasticsearch service to start automatically using systemd
		 sudo systemctl daemon-reload
		 sudo systemctl enable elasticsearch.service
		### You can start elasticsearch service by executing
		 sudo systemctl start elasticsearch.service
		Created elasticsearch keystore in /etc/elasticsearch

2. 修改配置文件

	配置文件一般存放在/etc/elasticsearch目录下

		vi elasticsearch.yml
		开启远程访问
		network.host 0.0.0.0
		修改端口
		
	

3. 启动服务

		sudo systemctl daemon-reload
		sudo systemctl enable elasticsearch.service
		sudo systemctl start elasticsearch.service

	
4. 测试启动状态
	
		netstat -lntp | grep -E "9200|9300"

### 常用命令 ###

	curl -X<REST Verb> <Node>:<Port>/<Index>/<Type>/<ID>

参数：

　　<REST Verb>：REST风格的语法谓词

　　<Node>:节点ip

　　<port>:节点端口号，默认9200

　　<Index>:索引名

　　<Type>:索引类型

　　<ID>:操作对象的ID号

查看健康状态

	curl 'localhost:9200/_cat/health?v'
	epoch      timestamp cluster       status node.total node.data shards pri relo init unassign pending_tasks max_task_wait_time active_shards_percent
	1535546872 20:47:52  elasticsearch yellow          1         1      5   5    0    0        5             0                  -                 50.0%

查看节点列表

	curl 'localhost:9200/_cat/nodes?v'
	ip              heap.percent ram.percent cpu load_1m load_5m load_15m node.role master name
	192.168.117.133           22          32   2    0.00    0.02     0.05 mdi       *      M48aNzY


查看索引列表

	curl 'localhost:9200/_cat/indices?v'
	health status index    uuid                   pri rep docs.count docs.deleted store.size pri.store.size
	yellow open   customer FWs0PsZ0QAOJZ0W6l-HhLA   5   1          0            0      1.2kb          1.2kb

创建索引

	curl -XPUT 'localhost:9200/customer?pretty'

  	url -XPUT 'localhost:9200/customer/external/1?pretty' -d '{"name": "John Doe"}' 
	
	curl -H "Content-Type: application/json" -XPOST http://localhost:9200/kiwi/ksay/ -d '{ "author": "rococojie", "message": "I am beautiful"}'

	curl -H "Content-Type: application/json" -XPOST http://localhost:9200/kiwi/ksay/1 -d '{"author": "jerry", "message": "I hate Tom"}'

删除索引

	curl -XDELETE 'localhost:9200/customer?pretty'

修改索引

	curl -XPUT 'localhost:9200/customer/external/1?pretty' -d '{"name": "John Doe"}'

	curl -XPOST 'localhost:9200/customer/external/1/_update?pretty' -d '{"doc": { "name": "Jane Doe" }}'

获取指定索引

	curl -XGET 'localhost:9200/customer/external/1?pretty'


如果想通过远程浏览器访问，需要修改elasticsearch.yml文件。rpm安装的elasticsearch.yml存放在/etc/elasticsearch/文件夹下。如果找不到，可以通过rpm -ql elasticsearch查找。

	network.host 0.0.0.0


web界面化管理可以使用GitHub上开源的elasticsearch-head。