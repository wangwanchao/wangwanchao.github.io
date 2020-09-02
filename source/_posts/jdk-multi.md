---
title: 不同系统搭建多版本的jdk
tags: jdk
date: 2020-08-30 11:14:25
categpries: Java
---
dmg按照步骤安装jdk，我目前感兴趣的主要是jdk8、jdk11，所以这里只有两个版本，jdk在Windows、Mac、Linux支持多版本安装，这个可是太爽了，一个命令切换。

<!-- more -->
## Mac系统
查看jdk版本、安装目录
```
	java -version
	which java
	ll /usr/bin/java
	cd /System/Library/Frameworks/JavaVM.framework/Versions
```
查看可用的jdk版本
```
	ls
	ll
```
查看已经安装的jdk
```
	/usr/libexec/java_home -V
```
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
```
	jdk8
	java -version
```
遇到的问题：

1. 在Versions目录查看jdk版本时没有列出所有的可用版本

## Linux系统
### Ubuntu/Deepin安装
安装
```
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-11/bin/java 300  

sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-11/bin/java 300 -slave /usr/bin/javac /usr/lib/jvm/jdk-11/bin/javac
```
切换版本
```
sudo update-alternatives --config java
```
卸载指定版本
```
sudo update-alternatives --remove java /usr/lib/jvm/jdk-11/bin/java
```

### 补充：
update-alternatives命令
命令：
  --install <链接> <名称> <路径> <优先级>
    [--slave <链接> <名称> <路径>] ...
                           在系统中加入一组候选项。
  --remove <名称> <路径>   从 <名称> 替换组中去除 <路径> 项。
  --remove-all <名称>      从替换系统中删除 <名称> 替换组。
  --auto <名称>            将 <名称> 的主链接切换到自动模式。
  --display <名称>         显示关于 <名称> 替换组的信息。
  --query <名称>           机器可读版的 --display <名称>.
  --list <名称>            列出 <名称> 替换组中所有的可用候选项。
  --get-selections         列出主要候选项名称以及它们的状态。
  --set-selections         从标准输入中读入候选项的状态。
  --config <名称>          列出 <名称> 替换组中的可选项，并就使用其中
                           哪一个，征询用户的意见。
  --set <名称> <路径>      将 <路径> 设置为 <名称> 的候选项。
  --all                    对所有可选项一一调用 --config 命令。

<链接> 是指向 /etc/alternatives/<名称> 的符号链接。
    (如 /usr/bin/pager)
<名称> 是该链接替换组的主控名。
    (如 pager)
<路径> 是候选项目标文件的位置。
    (如 /usr/bin/less)
<优先级> 是一个整数，在自动模式下，这个数字越高的选项，其优先级也就越高。
