---
title: 树莓派系统搭建踩坑
date: 2018-04-26 18:43:00
categories: raspberry
tags: 树莓派
---

### 一、安装树莓派系统
1、SDFormatter格式化优盘

2、win32Disk写入镜像

3、pi用户登录系统，pi/raspberry

<!-- more -->

### 二、修改键盘布局(因为树莓派默认英国键盘布局，会导致出错
	sudo raspi-config

> 1. Locals Options

> 2. Choose Keyword Layout

> 3. Generic 104-key PC #键盘101布局和104布局

> 4. English(US, alternative international)

	
重启系统

    reboot

### 三、设置远程登录，使用xshell操作

开启22号端口
	sudo raspi-config

> 1、Advanced Options

> 2、SSH Enable

树莓派默认pi用户，开启root用户
	sudo passwd root

	sudo passwd --unlock root

	su root

设置允许root用户远程登录系统

	vi /etc/ssh/sshd_config

> PermitRootLogin yes

	reboot

### 四、配置WiFi

	su root
	vi /etc/wpa_supplicant/wpa_supplicant.conf

> network={
> 
> 	ssid="wifi名称"
> 
> 	psk="wifi密码"
> }

重启查看网络

	reboot
	ifconfig wlan0

### 五、卸载系统自带vim，安装vim(自带vim上下左右键盘为ABCD)

	apt-get remove vim-common
	apt-get install vim

### 六、修改镜像源
vi /etc/apt/sources.list

deb http://mirrors.aliyun.com/raspbian/raspbian/ stretch main contrib non-free rpi 
deb-src http://mirrors.aliyun.com/raspbian/raspbian/ stretch main contrib non-free rpi 

	vi /etc/apt/sources.list.d/raspi.list

更新源

	sudo apt-get update
	sudo apt-get upgrade -y