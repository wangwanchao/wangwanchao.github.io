---
title: Jenkins
date: 2018-11-27 20:43:42
tags: Jenkins
categories: Jenkins
---
### yum安装

```
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

yum install jenkins

```

### 修改配置

```
vim /etc/sysconfig/jenkins

修改端口
JENKINS_PORT="8082"

修改启动用户
JENKINS_USER="jenkins"

```

上面rpm、yum安装后已经自动创建了jenkins用户，可以根据具体情况调整启动用户

### 启动/开机启动

```
service jenkins start

```
