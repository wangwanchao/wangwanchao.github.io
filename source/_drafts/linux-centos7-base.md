---
title: Centos7系统安装
date: 2018-11-27 20:07:12
tags: Linux
categories: Linux
---
自从几年前折腾过win7+ubuntu14双系统后(大致还记得什么EasyBCD修改引导什么的)，一般都是在VMware搭建虚拟机，这次主机从win10切换到Centos7，中间踩到的坑记录一下。

<!-- more -->
## 重启引导问题

因为原来安装了win10，导致U盘重装无法进入引导界面，总是很快进入win10，后来看到说明使用'F12'进入Menu启动配置页面，有个BOOT、UFEI，在BOOT中选择USB那个，进入安装界面


## 分区问题

win10分盘都是按照NTFS格式分的，导致手动分区时'点这里自动创建分区'报错，'磁盘占满'，可以选择右侧的'更新设置'对NTFS格式的分区改为ext4格式。

不同分区配置方案：

一般新手建议使用默认分区，

### 方案1
1. '/'：**BISO BOOT格式**建议大小在5GB以上。
2. 'swap'：即交换分区，建议大小是物理内存的1~2倍。

### 方案2
1. '/boot'：**BISO BOOT格式**用来存放与Linux系统启动有关的程序，比如启动引导装载程序等，建议大小为100MB。
2. '/'：**ext4**Linux系统的根目录，所有的目录都挂在这个目录下面，建议大小为5GB以上。
3. 'swap'：**swap**实现虚拟内存，建议大小是物理内存的1~2倍。
4. '/home'：**ext4**存放普通用户的数据，是普通用户的宿主目录，建议大小为剩下的空间。

### 方案3

1. /boot：**BISO BOOT格式**用来存放与Linux系统启动有关的程序，比如启动引导装载程序等，建议大小为100MB。
2. /usr ：用来存放Linux系统中的应用程序，其相关数据较多，建议大于3GB以上。
3. /var ：用来存放Linux系统中经常变化的数据以及日志文件，建议大于1GB以上。
4. swap：实现虚拟内存，建议大小是物理内存的1~2倍。
5. / ：Linux系统的根目录，所有的目录都挂在这个目录下面，建议大小为5GB以上。
6. /tmp：将临时盘在独立的分区，可避免在文件系统被塞满时影响到系统的稳定性。建议大小为500MB以上。
7. /home：存放普通用户的数据，是普通用户的宿主目录，建议大小为剩下的空间。


## 网络设置

IP、网关
