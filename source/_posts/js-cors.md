---
title: js-cors
date: 2018-12-16 23:16:01
tags: JavaScript
categpries: JavaScript
---
跨域其实很早就用，当时也没有整理，CSRF、CORS

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
3. JSONP方式。通过script标签发起请求，服务端把数据放在js脚本里返回给客户端，但是只支持GET请求。CDN就是典型的应用。jQuery封装的JSONP






