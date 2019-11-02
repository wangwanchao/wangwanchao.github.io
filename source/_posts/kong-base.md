---
title: Kong网关--
date: 2019-08-29 14:29:21
tags: SpringCloud
categpries: SpringCloud
---


<!-- more -->
## Centos7安装

	yum install -y gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel
	
	
如果配置了yum源，可以直接yum安装

#### 配置yum源
	sudo yum update -y
	sudo yum install -y wget
	wget https://bintray.com/kong/kong-rpm/rpm -O bintray-kong-kong-rpm.repo
	export major_version=`grep -oE '[0-9]+\.[0-9]+' /etc/redhat-release | cut -d "." -f1`
	sed -i -e 's/baseurl.*/&\/centos\/'$major_version''/ bintray-kong-kong-rpm.repo
	sudo mv bintray-kong-kong-rpm.repo /etc/yum.repos.d/
	sudo yum update -y
	sudo yum install -y kong
	
#### 有数据库模式
依赖于PostgreSQL

创建kong.conf

	cp /etc/kong/kong.conf.default /etc/kong/kong.conf

报错：
1. Error: [PostgreSQL error] failed to check legacy schema state: ERROR: function to_regclass(unknown) does not exist (12)

  Run with --v (verbose) or --vv (debug) for more details
解决方案：postgresql版本不兼容问题，升级psql

#### 无数据库模式


#### 启动


### kong监控UI
kong-dashboard

1、
2、重新启动报错：
kong-dashboard start --kong-url http://kong:8001
Connecting to Kong on http://kong:8001 ...
Could not reach Kong on http://kong:8001
Error details:
{ Error: getaddrinfo ENOTFOUND kong kong:8001
    at GetAddrInfoReqWrap.onlookup [as oncomplete] (dns.js:56:26)
  errno: 'ENOTFOUND',
  code: 'ENOTFOUND',
  syscall: 'getaddrinfo',
  hostname: 'kong',
  host: 'kong',
  port: '8001' }

### konga