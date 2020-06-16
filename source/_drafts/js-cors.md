---
title: js跨域问题
date: 2018-12-16 23:16:01
tags: JavaScript
categpries: JavaScript
---
跨域其实很早就用，当时也没有整理。

CORS: CORS的目的不是为了解决CSRF，无法防止CSRF发生

CSRF: (Cross-site request forgery，跨站请求伪造)，CSRF攻击的发起方式有很多种，src资源标签、form表单、js代码


[跨域:阮老师的博客](https://www.ruanyifeng.com/blog/2016/04/cors.html)

<!-- more -->

## 同源策略 ##

同源：
> 协议相同
> 
> 域名相同
> 
> 端口相同


受限制的策略：

1. Ajax请求
2. 无法获取DOM元素并操作
3. 无法读取Cookie、LocalStorage、IndexDB


不受限制的策略：

WebSocket、Script、img、iframe、video、audio的src属性

## 跨域场景 ##

调用API接口

前后端分离


## 解决方案 ##

1. 代理模式。分为正向代理、反向代理，自己伪造一个后端服务(例如Nodejs)接收并转发
2. CORS标准。服务端设置'Access-Control-Allow-Origin' + 'Access-Control-Allow-Credentials'，客户端设置withCredentials

	**注意：**CORS默认不发送Cookie和HTTP认证信息，Credentials用来指定发送Cookie信息。如果要发送Cookie，'Access-Control-Allow-Origin'不能设置为'*'，而必须指定明确的、与请求网页一致的域名。

3. JSONP方式。通过script标签发起请求，服务端把数据放在js脚本里返回给客户端，但是只支持GET请求。CDN就是典型的应用。jQuery封装的JSONP






