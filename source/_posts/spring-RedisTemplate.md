---
title: RedisTemplate
date: 2018-06-16 10:06:06
tags:
---
Spring Data Redis(SDR) 2.x
需要JDK8+、Spring Framework5.0.7+、Redis2.6.x

2、整合了Lettuce和Jedis两个开源库

3、高可见性

可以直接使用底层(本地库)直接连接Redis

RedisConnection
可以传递底层链接库异常到Spring持久化层DAO层，

使用RedisConnectionFactory创建RedisConncection,RedisConnectionFactory继承PersistenceExceptionTranslator对象，意味着异常操作对RedisConnectionFactory更透明化。

目前并不是所有的SDR特性都被connector开源库支持，使用不支持的特性会抛出
UnsupportedOperationException异常。

<!-- more -->

二、Lettuce
Lettuce是基于Netty的连接器

1、默认情况下，所有的LettuceConnection被LettuceConnectionFactory创建，它们共享一个线程安全的本地连接执行非阻塞、非事务性操作。

2、LettuceConnectionFactory可以通过配置使用LettucePool

3、LettuceConnectionFactory通过设置shareNativeConnection=false使用事务性连接

三、Jedis

四、RedisTemplate
1、提供了更高层的抽象，更关注序列化、连接的管理。
RedisConnection则提供了底层方法可以操作二进制数据。

2、一旦被配置，则是线程安全的，可以被多个实例重用，

3、默认基于Java原生序列类进行序列化，则所有的对象读写都是经过序列化和反序列化的。SDR在org.springframework.data.redis.serializer包内提供了一些其它的序列化实现类。可以通过设置所有的序列器为null同时设置enableDefaultSerializer=false。
***注意：RedisTemplate要求所有的属性key不能为空，value可以为空***

特殊的String操作：
StringRedisConnection
StringRedisTemplate
StringRedisSerializer

两种serializers都基于RedisSerializer
Element读写使用RedisElementReader、RedisElementWriter
RedisCache和RedisTemplate默认使用JdkSerializationRedisSerializer

OxmSerializer用于基于Object/XML mapping

Jackson2JsonRedisSerializer / GenericJackson2JsonRedisSerializer用于json格式数据

***如果安全更重要，可以考虑在JVM层使用特殊的filter机制***

使用Redis Hash可以存储更复杂的结构化对象：
(1)HashOperations + serializer
(2)Redis Repositories
(3)HashMapper + HashOperations
BeanUtilsHashMapper

ObjectHashMapper

Jackson2HashMapper


五、Reactive Redis(异步)
ReactiveRedisConnection

ReactiveRedisTemplate


六、Redis Cluster
RedisClusterConnection继承RedisConnection，通过RedisConnectionFactory创建，RedisClusterFactory配置属性

redisTemplate.opsForCluster();


七、Redis Repository

要求：Redis Server2.8.0+

CrudRepository

RedisConverter

TTL

KeySpaces

@Reference注解

CDI Integration



