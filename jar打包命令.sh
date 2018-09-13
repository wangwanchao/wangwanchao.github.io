jar打包命令

1、替换war包中的文件
找到文件在war包中的绝对路径
在war同级目录创建对应的文件目录
执行 jar -uvf lb-workflow.war  WEB-INF/classes/application-dev.yml

2、war打包
jar cvf lb-workflow.war lb-workflow/*

#报错
java -jar lb-workflow.war 
lb-workflow.war中没有主清单属性
no main manifest attribute, in lb-workflow.war
#解决 指定清单文件
jar -cfm lb-workflow.war lb-workflow-bak/META-INF/MANIFEST.MF lb-workflow-bak/*
#报错
错误: 找不到或无法加载主类 org.springframework.boot.loader.WarLauncher

jar -cvfm lb-test.war lb-workflow-bak/META-INF/MANIFEST.MF -C lb-workflow-bak/ .
#报错
Exception in thread "main" java.lang.IllegalStateException: Failed to get nested archive for entry WEB-INF/lib-provided/tomcat-embed-el-8.5.31.jar
	at org.springframework.boot.loader.archive.JarFileArchive.getNestedArchive(JarFileArchive.java:108)
	at org.springframework.boot.loader.archive.JarFileArchive.getNestedArchives(JarFileArchive.java:86)
	at org.springframework.boot.loader.ExecutableArchiveLauncher.getClassPathArchives(ExecutableArchiveLauncher.java:70)
	at org.springframework.boot.loader.Launcher.launch(Launcher.java:49)
	at org.springframework.boot.loader.WarLauncher.main(WarLauncher.java:58)
Caused by: java.io.IOException: Unable to open nested jar file 'WEB-INF/lib-provided/tomcat-embed-el-8.5.31.jar'
	at org.springframework.boot.loader.jar.JarFile.getNestedJarFile(JarFile.java:254)
	at org.springframework.boot.loader.jar.JarFile.getNestedJarFile(JarFile.java:239)
	at org.springframework.boot.loader.archive.JarFileArchive.getNestedArchive(JarFileArchive.java:103)
	... 4 more
Caused by: java.lang.IllegalStateException: Unable to open nested entry 'WEB-INF/lib-provided/tomcat-embed-el-8.5.31.jar'. It has been compressed and nested jar files must be stored without compression. Please check the mechanism used to create your executable jar file
	at org.springframework.boot.loader.jar.JarFile.createJarFileFromFileEntry(JarFile.java:282)
	at org.springframework.boot.loader.jar.JarFile.createJarFileFromEntry(JarFile.java:262)
	at org.springframework.boot.loader.jar.JarFile.getNestedJarFile(JarFile.java:250)
	... 6 more
#解决 不压缩打包
jar -cvfm0 lb-test.war lb-workflow-bak/META-INF/MANIFEST.MF -C lb-workflow-bak/ .
#报错
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/Applications/tomcat-8.5.34/webapps/lb-test.war!/WEB-INF/lib/slf4j-log4j12-1.7.25.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/Applications/tomcat-8.5.34/webapps/lb-test.war!/WEB-INF/lib/logback-classic-1.2.3.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.slf4j.impl.Log4jLoggerFactory]
Exception in thread "main" java.lang.reflect.InvocationTargetException
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at org.springframework.boot.loader.MainMethodRunner.run(MainMethodRunner.java:48)
	at org.springframework.boot.loader.Launcher.launch(Launcher.java:87)
	at org.springframework.boot.loader.Launcher.launch(Launcher.java:50)
	at org.springframework.boot.loader.WarLauncher.main(WarLauncher.java:58)
Caused by: java.lang.IllegalArgumentException: LoggerFactory is not a Logback LoggerContext but Logback is on the classpath. Either remove Logback or the competing implementation (class org.slf4j.impl.Log4jLoggerFactory loaded from jar:file:/Applications/tomcat-8.5.34/webapps/lb-test.war!/WEB-INF/lib/slf4j-log4j12-1.7.25.jar!/). If you are using WebLogic you will need to add 'org.slf4j' to prefer-application-packages in WEB-INF/weblogic.xml: org.slf4j.impl.Log4jLoggerFactory
	at org.springframework.util.Assert.instanceCheckFailed(Assert.java:637)
	at org.springframework.util.Assert.isInstanceOf(Assert.java:537)
	at org.springframework.boot.logging.logback.LogbackLoggingSystem.getLoggerContext(LogbackLoggingSystem.java:274)
	at org.springframework.boot.logging.logback.LogbackLoggingSystem.beforeInitialize(LogbackLoggingSystem.java:99)
	at org.springframework.boot.context.logging.LoggingApplicationListener.onApplicationStartingEvent(LoggingApplicationListener.java:191)
	at org.springframework.boot.context.logging.LoggingApplicationListener.onApplicationEvent(LoggingApplicationListener.java:170)
	at org.springframework.context.event.SimpleApplicationEventMulticaster.doInvokeListener(SimpleApplicationEventMulticaster.java:172)
	at org.springframework.context.event.SimpleApplicationEventMulticaster.invokeListener(SimpleApplicationEventMulticaster.java:165)
	at org.springframework.context.event.SimpleApplicationEventMulticaster.multicastEvent(SimpleApplicationEventMulticaster.java:139)
	at org.springframework.context.event.SimpleApplicationEventMulticaster.multicastEvent(SimpleApplicationEventMulticaster.java:127)
	at org.springframework.boot.context.event.EventPublishingRunListener.starting(EventPublishingRunListener.java:68)
	at org.springframework.boot.SpringApplicationRunListeners.starting(SpringApplicationRunListeners.java:48)
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:313)
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:1255)
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:1243)
	at com.lbonline.workflow.LBWorkFlowApplication.main(LBWorkFlowApplication.java:25)
	... 8 more
#解决 删除slfg4j jar包

#报错
Exception in thread "main" java.lang.IllegalStateException: Failed to get nested archive for entry WEB-INF/lib/.DS_Store
	at org.springframework.boot.loader.archive.JarFileArchive.getNestedArchive(JarFileArchive.java:108)
	at org.springframework.boot.loader.archive.JarFileArchive.getNestedArchives(JarFileArchive.java:86)
	at org.springframework.boot.loader.ExecutableArchiveLauncher.getClassPathArchives(ExecutableArchiveLauncher.java:70)
	at org.springframework.boot.loader.Launcher.launch(Launcher.java:49)
	at org.springframework.boot.loader.WarLauncher.main(WarLauncher.java:58)
Caused by: java.io.IOException: Unable to open nested jar file 'WEB-INF/lib/.DS_Store'
	at org.springframework.boot.loader.jar.JarFile.getNestedJarFile(JarFile.java:254)
	at org.springframework.boot.loader.jar.JarFile.getNestedJarFile(JarFile.java:239)
	at org.springframework.boot.loader.archive.JarFileArchive.getNestedArchive(JarFileArchive.java:103)
	... 4 more
Caused by: java.io.IOException: Unable to find ZIP central directory records after reading 6149 bytes
	at org.springframework.boot.loader.jar.CentralDirectoryEndRecord.<init>(CentralDirectoryEndRecord.java:65)
	at org.springframework.boot.loader.jar.CentralDirectoryParser.parse(CentralDirectoryParser.java:52)
	at org.springframework.boot.loader.jar.JarFile.<init>(JarFile.java:121)
	at org.springframework.boot.loader.jar.JarFile.<init>(JarFile.java:109)
	at org.springframework.boot.loader.jar.JarFile.createJarFileFromFileEntry(JarFile.java:287)
	at org.springframework.boot.loader.jar.JarFile.createJarFileFromEntry(JarFile.java:262)
	at org.springframework.boot.loader.jar.JarFile.getNestedJarFile(JarFile.java:250)
	... 6 more



3、改用mvn打包

#进入war中pom所在文件夹
执行 mvn install
#报错
[FATAL] Non-parseable POM /Users/wanchaowang/.m2/repository/org/apache/apache/18/apache-18.pom: 
in epilog non whitespace content is not allowed but got r 

mvn -X install
#报错
[ERROR] The build could not read 1 project -> [Help 1]
org.apache.maven.project.ProjectBuildingException: Some problems were encountered while processing the POMs:
[FATAL] Non-parseable POM /Users/wanchaowang/.m2/repository/org/apache/apache/18/apache-18.pom: in epilog non whitespace content is not allowed but got r (position: END_TAG seen ...</profiles>\n</project>\nr... @417:2)  @ /Users/wanchaowang/.m2/repository/org/apache/apache/18/apache-18.pom, line 417, column 2
#解决 到.m2下删除apache/18文件夹

#报错
[ERROR] Failed to execute goal org.springframework.boot:spring-boot-maven-plugin:2.0.3.RELEASE:repackage (default) on project lb-workflow: Execution default of goal org.springframework.boot:spring-boot-maven-plugin:2.0.3.RELEASE:repackage failed: Unable to find main class -> [Help 1]
org.apache.maven.lifecycle.LifecycleExecutionException: Failed to execute goal org.springframework.boot:spring-boot-maven-plugin:2.0.3.RELEASE:repackage (default) on project lb-workflow: Execution default of goal org.springframework.boot:spring-boot-maven-plugin:2.0.3.RELEASE:repackage failed: Unable to find main class



解压war包
jar -xvf lb-workflow.war




