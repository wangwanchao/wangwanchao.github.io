---
title: session-cookie-token
date: 2018-12-19 13:01:12
tags:
categpries:
---
## Session
原理：存储在服务器上，服务器使用session把用户信息存储在服务器上(内存存放)，用户离开网站后，一般是30分钟后失效。

结构：

弊端：不适合分布式，如果有负载均衡，如果登录后，操作请求到另外的服务器，session不起作用

## Cookie
cookie是保存在浏览器本地的kv数据，由服务器生成，返给客户端(浏览器)，

结构：
> 名称
> 	
> 值
> 
> 有效域
> 
> 路径
> 
> 失效时间
> 
> 安全标志
	


## Token
原理：

结构：
> 用户唯一身份标识
> time 当前时间时间戳
> sign 签名，hash(token前几位+salt)，可以防止第三方拼接
> 不变参数
> 


### session和cookie

### session和token
1. token是无状态的，存储在客户端；session有状态，状态存储在服务器端。REST是无状态的，app不需要像浏览器那样存储cookie
2. token安全性比较好，可以防止监听、重防攻击；session保证安全需要靠链路层实现
3. token是唯一的，提供认证 + 鉴权；session是把用户信息存在服务器，只要有sessionid，即认为有全部权利。如果接口给第三方调用，使用token，否则两者都可
4. 





