---
title: Nexus私服
date: 2018-09-23 13:21:06
tags: Nexus
categoties: Nexus
---
私服的搭建一般是运维的工作，作为有追求的程序猿。。。


<!-- more -->


## 环境搭建 ##

**依赖于jdk**

### yum安装 ###




### tar.gz安装 ###

```

cd /usr/local

tar -xzvf nexus-3.14.0-unix.tar.gz

mv nexus-3.14.0 nexus

cd nexus/bin

ln -s nexus nexus

vi nexus.rc

创建nexus用户

useradd nexus

修改启动用户

run_as_user="nexus"

修改启动端口



```

### 开机自启动 ###

vi /etc/systemd/system/nexus.service

```
[Unit]
Description=nexus service
After=network.target
	
[Service]
Type=forking
ExecStart=/usr/local/nexus/bin/nexus start
ExecStop=/usr/local/nexus/bin/nexus stop
User=nexus
Restart=on-abort
	
[Install]
WantedBy=multi-user.target

```

systemctl daemon-reload

systemctl enable nexus

systemctl start nexus

### 防火墙规则 ###

### 浏览器访问 ###

http://ip:8081/nexus

默认用户 admin/admin123




## nexus模块 ##

### 仓库类型 ###

maven

nuget

### jar版本 ###

snapshot

release

### Type类型： ###

proxy: 当私有nexus找不到依赖包时，就会通过代理查找

hosted: 私有的依赖包存储在这里

group: 包含proxy和hosted类型，是一个聚合体。


### Format ###


### Storage ###

Blob store

### Maven 2 ###

version policy: Release、Snapshot、Mixed


