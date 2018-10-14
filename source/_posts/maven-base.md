---
title: maven配置文件
date: 2018-09-27 16:30:55
tags: Maven
categories: Maven
---
一直在用maven，其实对maven并没有非常深入理解，任重道远啊。最近一个项目编译的时候，开始使用Plugins--install--install:install命令，编译报错：

<!-- more -->

	[ERROR] Failed to execute goal org.apache.maven.plugins:maven-install-plugin:2.5.2:install (default-cli) on project StarTeamCollisionUtil: The packaging for this project did not assign a file to the build artifact -> [Help 1]

后来使用Lifecycle--install，编译成功；使用maven clean install也会成功。最后查看[StackOverflow](https://stackoverflow.com/questions/6308162/maven-the-packaging-for-this-project-did-not-assign-a-file-to-the-build-artifac)

大致意思：install:install命令是插件maven-install-plugin中的命令，不同于Lifecycle中的install命令。

mvn clean install在每个周期中会运行所有的命令，包括：compile、package、test等等。

mvn clean install:install则只会install一个命令，甚至不包括compile、package

通过IDEA的maven了解maven的结构：

![maven结构](http://pciqklc7l.bkt.clouddn.com/maven.PNG)

### Lifecycle和Plugins ###

### plubins标签和pluginManagement标签 ###

### dependencyManagement标签和dependencies标签 ###