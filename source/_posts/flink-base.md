---
title: flink-base
date: 2018-10-25 14:30:35
tags: Flink
categories: Flink
---
根据官网示例，跑一下

1. 启动flink

		cd $FLINK_HOME/libexec
		bin/start-cluster.sh

	flink自带WebUI，可以通过浏览器访问：localhost:8081
	
<!-- more -->
2. IDEA根据flink-quickstart-scala框架创建demo项目

	```

	package com.wang
	
	import org.apache.flink.api.java.utils.ParameterTool
	import org.apache.flink.streaming.api.scala._
	import org.apache.flink.streaming.api.windowing.time.Time
	
	/**
	 * Skeleton for a Flink Streaming Job.
	 *
	 * For a tutorial how to write a Flink streaming application, check the
	 * tutorials and examples on the <a href="http://flink.apache.org/docs/stable/">Flink Website</a>.
	 *
	 * To package your application into a JAR file for execution, run
	 * 'mvn clean package' on the command line.
	 *
	 * If you change the name of the main class (with the public static void main(String[] args))
	 * method, change the respective entry in the POM.xml file (simply search for 'mainClass').
	 */
	object StreamingJob {
	
	  // raw原生
	//  def main(args: Array[String]) {
	//    // set up the streaming execution environment
	//    val env = StreamExecutionEnvironment.getExecutionEnvironment
	//
	//    /*
	//     * Here, you can start creating your execution plan for Flink.
	//     *
	//     * Start with getting some data from the environment, like
	//     *  env.readTextFile(textPath);
	//     *
	//     * then, transform the resulting DataStream[String] using operations
	//     * like
	//     *   .filter()
	//     *   .flatMap()
	//     *   .join()
	//     *   .group()
	//     *
	//     * and many more.
	//     * Have a look at the programming guide:
	//     *
	//     * http://flink.apache.org/docs/latest/apis/streaming/index.html
	//     *
	//     */
	//
	//    // execute program
	//    env.execute("Flink Streaming Scala API Skeleton")
	//  }
	
	  def main(args: Array[String]) : Unit = {
	
	    // the port to connect to
	    val port: Int = try {
	      ParameterTool.fromArgs(args).getInt("port")
	    } catch {
	      case e: Exception => {
	        System.err.println("No port specified. Please run 'SocketWindowWordCount --port <port>'")
	        return
	      }
	    }
	
	    // get the execution environment
	    val env: StreamExecutionEnvironment = StreamExecutionEnvironment.getExecutionEnvironment
	
	    // get input data by connecting to the socket
	    val text = env.socketTextStream("localhost", port, '\n')
	
	    // parse the data, group it, window it, and aggregate the counts
	    val windowCounts = text
	      .flatMap { w => w.split("\\s") }
	      .map { w => WordWithCount(w, 1) }
	      .keyBy("word")
	      .timeWindow(Time.seconds(5), Time.seconds(1))
	      .sum("count")
	
	    // print the results with a single thread, rather than in parallel
	    windowCounts.print().setParallelism(1)
	
	    env.execute("Socket Window WordCount")
	  }
	
	  // Data type for words with count
	  case class WordWithCount(word: String, count: Long)
	}

	```
3. mvn编译项目

	mvn package/install编译过程报错
	
		error: could not find implicit value for evidence parameter of type org.apache.flink.api.common.typeinfo.TypeInformation[String]
		[ERROR]       .flatMap { w => w.split("\\s") }
	说这是因为程序需要一个隐形参数导致的，引用包改为'	import org.apache.flink.streaming.api.scala._
'重新编译，解决问题

4. 终端启动一个窗口

		nc -l 9000
	
5. 执行程序

		flink run SocketWindowWordCount.jar --port 9000
		
	运行报错：
		
		```
			org.apache.flink.client.program.ProgramInvocationException: The program's entry point class 'com.wang.StreamingJob' was not found in the jar file.
		at org.apache.flink.client.program.PackagedProgram.loadMainClass(PackagedProgram.java:617)
		at org.apache.flink.client.program.PackagedProgram.<init>(PackagedProgram.java:199)
		at org.apache.flink.client.program.PackagedProgram.<init>(PackagedProgram.java:128)
		at org.apache.flink.client.cli.CliFrontend.buildProgram(CliFrontend.java:856)
		at org.apache.flink.client.cli.CliFrontend.run(CliFrontend.java:206)
		at org.apache.flink.client.cli.CliFrontend.parseParameters(CliFrontend.java:1044)
		at org.apache.flink.client.cli.CliFrontend.lambda$main$11(CliFrontend.java:1120)
		at java.security.AccessController.doPrivileged(Native Method)
		at javax.security.auth.Subject.doAs(Subject.java:422)
		at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1754)
		at org.apache.flink.runtime.security.HadoopSecurityContext.runSecured(HadoopSecurityContext.java:41)
		at org.apache.flink.client.cli.CliFrontend.main(CliFrontend.java:1120)
		Caused by: java.lang.ClassNotFoundException: com.wang.StreamingJob
		at java.net.URLClassLoader.findClass(URLClassLoader.java:381)
		at java.lang.ClassLoader.loadClass(ClassLoader.java:424)
		at java.lang.ClassLoader.loadClass(ClassLoader.java:357)
		at java.lang.Class.forName0(Native Method)
		at java.lang.Class.forName(Class.java:348)
		at org.apache.flink.client.program.PackagedProgram.loadMainClass(PackagedProgram.java:614)
		... 11 more

		```
	在执行中默认StreamingJob类为主类，如果自定义类，需要指定主类名称。
		
6. 查看日志

		cd $FLINK_HOME/libexec/log
		tail -f flink-*-taskexecutor-*.out
	
7. 停止flink

		cd $FLINK_HOME/libexec
		bin/stop-cluster.sh


