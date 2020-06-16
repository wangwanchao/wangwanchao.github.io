---
title: maven配置文件
date: 2018-09-27 16:30:55
tags: Maven
categories: Maven
---
一直在用maven，其实对maven并没有非常深入理解，任重道远啊。最近一个项目编译的时候，开始使用Plugins--install--install:install命令，

<!-- more -->

编译报错：

	[ERROR] Failed to execute goal org.apache.maven.plugins:maven-install-plugin:2.5.2:install (default-cli) on project StarTeamCollisionUtil: The packaging for this project did not assign a file to the build artifact -> [Help 1]

后来使用Lifecycle--install，编译成功；使用maven clean install也会成功。最后查看[StackOverflow](https://stackoverflow.com/questions/6308162/maven-the-packaging-for-this-project-did-not-assign-a-file-to-the-build-artifac)

大致意思：install:install命令是插件maven-install-plugin中的命令，不同于Lifecycle中的install命令。

mvn clean install在每个周期中会运行所有的命令，包括：compile、package、test等等。

mvn clean install:install则只会install一个命令，甚至不包括compile、package

## 仓库
1. 本地仓库

2. 远程仓库

3. 中央仓库

先从本地仓库查找，再从私服查找，最后再到远处、中央仓库查找。

## setting.xml
### 镜像
用于配置速度更快的的仓库镜像，mirrorOf可以配置'central,*'不同仓库

```
<mirrors>  
    <mirror>  
      <id>maven-net-cn</id>  
      <name>Maven China Mirror</name>  
      <url>http://maven.net.cn/content/groups/public/</url>  
      <mirrorOf>central</mirrorOf>  
    </mirror>  
</mirrors>  
  
```

## pom.xml
### packaging类型

	<packaging></packaging>
	
### parent标签


### dependencies标签
1. compile：默认编译依赖范围。对于编译，测试，运行三种classpath都有效。如log4j
2. test：测试依赖范围。只对于测试classpath有效。如junit
3. provided：已提供依赖范围。对于编译，测试的classpath都有效，但对运行无效。servlet-api
4. runtime：运行时提供。例如：jdbc驱动。
最主要要区分compile和provided。

#### 依赖传递
原则：近路优先，声明优先

1. 当第二依赖的范围是compile的时候，传递性依赖的范围与第一直接依赖的范围一致。
2. 当第二直接依赖的范围是test的时候，依赖不会得以传递。
3. 当第二依赖的范围是provided的时候，只传递第一直接依赖范围也为provided的依赖，且传递性依赖的范围同样为 provided；
4. 当第二直接依赖的范围是runtime的时候，传递性依赖的范围与第一直接依赖的范围一致，但compile例外，此时传递的依赖范围为runtime；

#### 依赖冲突
在maven中存在两种冲突方式：一种是跨pom文件的冲突，一种是同一个pom文件的冲突

1. 如果直接与间接依赖中包含有同一个坐标不同版本的资源依赖，以直接依赖的版本为准（就近原则）
2. 同一个pom文件中的冲突。pom文件从上到下加载，那么下面的jar包会覆盖上面的jar包。这也体现了就近原则。

#### 可选依赖

	<optional>true/false</optional>

true，则表示该依赖不会传递下去
false，则会传递下去。

#### 排除依赖

```
	<exclusions>
		<exclusion>
        	<groupId>xxx</groupId>
        	<artifactId>xxx</artifactId>
    	</exclusion>
	</exclusions>
```

### Lifecycle生命周期

#### clean
1. pre-clean 执行一些需要在clean之前完成的工作；
2. clean 移除所有上一次构建生成的文件 ；
3. post-clean 执行一些需要在clean之后立刻完成的工作 。

mvn clean命令，等同于 mvn pre-clean clean。只要执行后面的命令，那么前面的命令都会执行，不需要再重新去输入命令。有Clean生命周期，在生命周期又有clean阶段。

#### default


#### site
1. pre-site 执行一些需要在生成站点文档之前完成的工作 ；
2. site 生成项目的站点文档 ；
3. post-site 执行一些需要在生成站点文档之后完成的工作，并且为部署做准备 ；
4. site-deploy 将生成的站点文档部署到特定的服务器上 。

### plugins ###

### pluginManagement标签 ###

### dependencyManagement标签

### distributionManagement标签
分发构件至远程仓库
