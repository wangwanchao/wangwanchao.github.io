---
title: mac系统搭建多版本的jdk
date: 2018-10-23 11:14:25
tags: Mac
categories: Mac
---

dmg按照步骤安装jdk，我目前感兴趣的主要是jdk8、jdk11，所以这里只有两个版本

<!-- more -->

查看jdk版本、安装目录

	java -version
	which java
	ll /usr/bin/java
	cd /System/Library/Frameworks/JavaVM.framework/Versions

查看可用的jdk版本

	ls
	ll

查看已经安装的jdk

	/usr/libexec/java_home -V

配置环境变量
	
	vi ~/.bash_profile

```
# 设置自带的 jdk1.6
#export JAVA_6_HOME=`/usr/libexec/java_home -v 1.6`
# 设置 jdk1.7
#export JAVA_7_HOME=`/usr/libexec/java_home -v 1.7`
# 设置 jdk1.8
export JAVA_8_HOME=`/usr/libexec/java_home -v 1.8`
# 设置 jdk11
export JAVA_11_HOME=`/usr/libexec/java_home -v 11`


# 默认 jdk 使用1.6版本
export JAVA_HOME=$JAVA_8_HOME

# alias 命令动态切换 jdk 版本
# alias jdk6="export JAVA_HOME=$JAVA_6_HOME"
# alias jdk7="export JAVA_HOME=$JAVA_7_HOME"
alias jdk8="export JAVA_HOME=$JAVA_8_HOME"
alias jdk11="export JAVA_HOME=$JAVA_11_HOME"

```

命令切换jdk版本

	jdk8
	java -version

遇到的问题：

1. 在Versions目录查看jdk版本时没有列出所有的可用版本