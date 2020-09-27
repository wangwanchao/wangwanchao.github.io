---
title: Elasticsearch环境(一)
date: 2020-09-10 22:35:37
tags: es
categories: Elasticsearch
---
2017年接触过一些ELK环境的搭建，用来处理日志信息，涉及到的东西很多，最近重新使用，对一些存储、索引更有兴趣。

<!-- more -->
## 环境搭建
依赖于JDK，对jdk版本、内存有要求，否则会启动失败

### tar.gz安装 ###
需要创建用户组、用户、非root用户启动

### rpm安装 ###

1. 直接安装，默认创建用户组
```
rpm -ivh elasticsearch-6.4.0.rpm
```
提示
```
正在升级/安装...
	1:elasticsearch-0:6.4.0-1          ################################# [100%]
### NOT starting on installation, please execute the following statements to configure elasticsearch service to start automatically using systemd
	sudo systemctl daemon-reload
	sudo systemctl enable elasticsearch.service
### You can start elasticsearch service by executing
	sudo systemctl start elasticsearch.service
Created elasticsearch keystore in /etc/elasticsearch
```
2. 修改配置文件，配置文件一般存放在/etc/elasticsearch目录下
```
vi elasticsearch.yml
# 开启远程访问
network.host 0.0.0.0
# 修改端口
```
3. 启动服务，设置开机自启动
```
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service
```
4. 测试启动状态
```
netstat -lntp | grep -E "9200|9300"
```
5. 查看版本，检验是否安装成功
```
curl -XGET localhost:9200
```

### 常用命令 ###
```
curl -X<REST Verb> <Node>:<Port>/<Index>/<Type>/<ID>
```
参数：
　　<REST Verb>：REST风格的语法谓词
　　<Node>:节点ip
　　<port>:节点端口号，默认9200
　　<Index>:索引名
　　<Type>:索引类型
　　<ID>:操作对象的ID号

查看健康状态
```
curl 'localhost:9200/_cat/health?v'
epoch      timestamp cluster       status node.total node.data shards pri relo init unassign pending_tasks max_task_wait_time active_shards_percent
1535546872 20:47:52  elasticsearch yellow          1         1      5   5    0    0        5             0                  -                 50.0%
```
查看节点列表
```
curl 'localhost:9200/_cat/nodes?v'
ip              heap.percent ram.percent cpu load_1m load_5m load_15m node.role master name
192.168.117.133           22          32   2    0.00    0.02     0.05 mdi       *      M48aNzY
```

查看索引列表
```
curl 'localhost:9200/_cat/indices?v'
health status index    uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   customer FWs0PsZ0QAOJZ0W6l-HhLA   5   1          0            0      1.2kb          1.2kb
```
创建索引
```
curl -XPUT 'localhost:9200/customer?pretty'

curl -XPUT 'localhost:9200/customer/external/1?pretty' -d '{"name": "John Doe"}' 

curl -H "Content-Type: application/json" -XPOST http://localhost:9200/kiwi/ksay/ -d '{ "author": "rococojie", "message": "I am beautiful"}'

curl -H "Content-Type: application/json" -XPOST http://localhost:9200/kiwi/ksay/1 -d '{"author": "jerry", "message": "I hate Tom"}'
```
删除索引
```
curl -XDELETE 'localhost:9200/customer?pretty'
```
修改索引
```
curl -XPUT 'localhost:9200/customer/external/1?pretty' -d '{"name": "John Doe"}'

curl -XPOST 'localhost:9200/customer/external/1/_update?pretty' -d '{"doc": { "name": "Jane Doe" }}'
```
获取指定索引
```
curl -XGET 'localhost:9200/customer/external/1?pretty'
```

如果想通过远程浏览器访问，需要修改`elasticsearch.yml`文件。rpm安装的elasticsearch.yml存放在`/etc/elasticsearch/`文件夹下。如果找不到，可以通过`rpm -ql elasticsearch`查找。
```
network.host 0.0.0.0
```
web界面化管理可以使用GitHub上开源的elasticsearch-head。

### 结合Kibana使用
kibana的安装非常简单，下载启动即可
1. 下载
```
wget https://artifacts.elastic.co/downloads/kibana/kibana-6.4.0-linux-x86_64.tar.gz

```

2. 修改配置
```
vi config/kibana.yml
```

3. 访问'localhost:5601'使用kibana

## 原理 ##
我个人的理解ES和MySQL的大致原理类似，无非都是对数据的存储，无非是基于内存模式，索引分析更快，更适用于全文搜索。
### 存储

### 索引
_index
_type
_id
_uid
索引的核心就是`类型映射`和`分析器`，在POST插入数据时es会默认创建索引，如果禁用默认，可以通过配置`elasticsearch.yml`。如果需要自定义分析器、字段属性的类型映射则需要手动创建索引。
**注意:`DELETE /_all`和`DELETE /*`会删除所有数据，可以通过`elasticsearch.yml`禁用**

索引格式：
```
PUT /index_test
{
    "settings": {
        "number_of_shards":   1,    # 每个索引的主分片数，默认是5
        "number_of_replicas": 0		# 每个主分片的副本数，默认是1
    }

}
```
#### 静态索引

#### 动态索引


### 分析器
分析器主要包括3种类型的函数：
1. 字符过滤器：
2. 分词器：。例如：关键词分词器、空格分词器、正则分词器
3. 词汇单元过滤器：例如：词干过滤器、
一个分析器可以有0个或者多个字符过滤器，但必须有一个唯一的分词器，

#### 内置分析器
standard分析器
1. standard分词器。
2. standard语义单元过滤器。
3. lowercase语汇单元过滤器。
4. stop语汇单元过滤器。

#### 自定义分析器
例如：对index_test索引自定义一个名为analyzer_custom的分析器
```
PUT /analyzer_test
{
    "settings": {
        "analysis": {
            "char_filter": {
                "&_to_and": {
                    "type": "mapping",
                    "mappings": [
                        "&=> and "
                    ]
                }
            },
            "filter": {
                "my_stopwords": {
                    "type": "stop",
                    "stopwords": [
                        "the",
                        "a"
                    ]
                }
            },
            "analyzer": {
                "analyzer_custom": {
                    "type": "custom",
                    "char_filter": [
                        "html_strip",
                        "&_to_and"
                    ],
                    "tokenizer": "standard",
                    "filter": [
                        "lowercase",
                        "my_stopwords"
                    ]
                }
            }
        }
    }
}

测试

```
可以在索引上使用分析器
```
PUT /my_index/_mapping/my_type
{
    "properties": {
        "title": {
            "type":      "string",
            "analyzer":  "analyzer_custom"
        }
    }
}
```

### 类型和映射
默认情况下，一个索引中的所有类型共享相同的字段和设置。例如：`/index_test/blog`和`/index_test/user`可以共享。
例如：索引data创建people类型的映射
```
PUT /
{
   "data": {
      "mappings": {
         "people": {
            "properties": {
               "name": {
                  "type": "string"
               },
               "address": {
                  "type": "string"
               }
            }
         }
      }
   }
}
```
#### 根对象
映射是一种层级结构，最高一层称为`根对象`，
属性
`properties`包含所有的字段，每个字段设置包括：
1. type
2. index
3. analyzer

元数据
`_source`用来存储数据记录。查询请求时可以通过`_source`指定特定字段只返回需要的字段。否则返回全部字段。也可以通过在设置映射时**禁用_source**

### 动态映射
在索引文档中添加属性时，索引遇到不认识的字段**默认**会自动创建映射。可以通过设置动态映射`"dynamic": "strict"`修改级别。
true: 新字段添加映射
false: 忽略新字段，但是在`_source`存储。
strict: 对新字段抛出异常。
动态模板
新增加的字段会使用默认的映射规则，也可以通过设置`dynamic_templates`自定义动态映射。

#### 嵌套映射

### 分片

### 搜索
#### 全字段搜索
`_all`代表匹配全部字段。如果不需要，也可以通过在映射中设置**禁用**。也可以在单独的字段上设置`"include_in_all": true`只针对个别字段全局过滤。