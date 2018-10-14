---
title: java-manifest
date: 2018-10-14 23:16:12
tags: java
categories: java
---
最近在javaassist项目中，要使用到MANIFEST.MF文件。MANIFEST.MF默认生成，如果需要自定义，在打包的时候需要明确指定：

看官方文档是最爽的，[jdk](https://docs.oracle.com/javase/7/docs/technotes/guides/jar/jar.html)
<!-- more -->

	<plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-jar-plugin</artifactId>
        <configuration>
            <archive>
                <manifestFile>src/main/resources/META-INF/MANIFEST.MF</manifestFile>
            </archive>
        </configuration>
    </plugin>

MANIFEST.MF放在META-INF目录下，从META-INF目录详细分析一下，META-INF支持4种类型，会被自动加载、解析，通常用于配置应用、扩展、类加载器、服务：

1. MENIFEST.MF
2. INDEX.LIST
3. xxx.SF
4. xxx.DSA
5. services/
6. maven/

## MANIFEST.MF ##

### 格式规则 ###

1. 基本格式  属性名称：(空格)属性值;
2. 每行最多72个字符，换行继续必须以空格开头 ;
文件最后一定是空行 ;
3. Class-Path 当前路径是jar包所在目录，如果要引用当前目录下一个子目录中的jar包，使用以下格式  

		子目录/jar包名称 子目录/jar名称,注意多个jar包之间用空格分隔, 在任何平台上路径分割符都是 /;
	
### 标签属性 ###

#### 1、一般属性 ####

1. Manifest-Version   用来定义manifest文件的版本，例如：Manifest-Version: 1.0
2. Archiver-Version: Plexus Archiver
3. Built-By: GGGGe
4. Created-By   声明该文件的生成者，一般该属性是由jar命令行工具生成的，例如：Created-By: Apache Maven 3.5.0
5. Build-Jdk: 1.8.0_161
6. Signature-Version   定义jar文件的签名版本
7. Class-Path  应用程序或者类装载器使用该值来构建内部的类搜索路径

#### 2、应用程序相关属性 ####

Main-Class   定义jar文件的入口类，该类必须是一个可执行的类，一旦定义了该属性即可通过 java -jar xxx.jar来运行该jar文件。

#### 3、包扩展属性 ####

#### 4、小程序(Applet)属性 ####

#### 5、扩展标识属性 ####

#### 6、签名属性 ####

#### 7、自定义属性 ####