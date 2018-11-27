---
title: spark-base
date: 2018-10-25 16:06:52
tags: Spark
categories: Spark
---

	bin/spark-shell 
	val textFile = spark.read.textFile("README.md")

报错：

	Caused by: org.apache.derby.iapi.error.StandardException: Failed to create database 'metastore_db', see the next exception for details.
	  at org.apache.derby.iapi.error.StandardException.newException(Unknown Source)
	  at org.apache.derby.impl.jdbc.SQLExceptionFactory.wrapArgsForTransportAcrossDRDA(Unknown Source)
	  ... 154 more
	Caused by: org.apache.derby.iapi.error.StandardException: Directory /usr/local/spark/metastore_db cannot be created.
	  at org.apache.derby.iapi.error.StandardException.newException(Unknown Source)
	  at org.apache.derby.iapi.error.StandardException.newException(Unknown Source)
	  at org.apache.derby.impl.services.monitor.StorageFactoryService$10.run(Unknown Source)
	  at java.security.AccessController.doPrivileged(Native Method)
	  at org.apache.derby.impl.services.monitor.StorageFactoryService.createServiceRoot(Unknown Source)
	  at org.apache.derby.impl.services.monitor.BaseMonitor.bootService(Unknown Source)
	  at org.apache.derby.impl.services.monitor.BaseMonitor.createPersistentService(Unknown Source)
	  at org.apache.derby.impl.services.monitor.FileMonitor.createPersistentService(Unknown Source)
	  at org.apache.derby.iapi.services.monitor.Monitor.createPersistentService(Unknown Source)
	  at org.apache.derby.impl.jdbc.EmbedConnection$5.run(Unknown Source)
	  at java.security.AccessController.doPrivileged(Native Method)
	  at org.apache.derby.impl.jdbc.EmbedConnection.createPersistentService(Unknown Source)
	  ... 151 more
