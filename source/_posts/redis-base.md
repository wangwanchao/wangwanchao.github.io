---
title: Redis环境搭建
date: 2020-08-27 23:07:26
tags:
categpries: Redis
---


<!-- more -->

## 编译安装
```
tar -xzvf 

cd redis-6.0.6
make
make install PREFIX=/usr/local/redis6
```

### 编译错误
1. make编译报错，gcc版本问题
```
In file included from server.c:30:0:
server.h:1051:5: 错误：expected specifier-qualifier-list before ‘_Atomic’
     _Atomic unsigned int lruclock; /* Clock for LRU eviction */
     ^
server.c: 在函数‘serverLogRaw’中:
server.c:1032:31: 错误：‘struct redisServer’没有名为‘logfile’的成员
     int log_to_stdout = server.logfile[0] == '\0';
                               ^
server.c:1035:23: 错误：‘struct redisServer’没有名为‘verbosity’的成员
     if (level < server.verbosity) return;
                       ^
server.c:1037:47: 错误：‘struct redisServer’没有名为‘logfile’的成员
     fp = log_to_stdout ? stdout : fopen(server.logfile,"a");
                                               ^
server.c:1050:47: 错误：‘struct redisServer’没有名为‘timezone’的成员
         nolocks_localtime(&tm,tv.tv_sec,server.timezone,server.daylight_active);
                                               ^
server.c:1050:63: 错误：‘struct redisServer’没有名为‘daylight_active’的成员
         nolocks_localtime(&tm,tv.tv_sec,server.timezone,server.daylight_active);
                                                               ^
server.c:1053:19: 错误：‘struct redisServer’没有名为‘sentinel_mode’的成员
         if (server.sentinel_mode) {
                   ^
server.c:1058:32: 错误：‘struct redisServer’没有名为‘masterhost’的成员
             role_char = (server.masterhost ? 'S':'M'); /* Slave or Master. */
                                ^
server.c:1066:15: 错误：‘struct redisServer’没有名为‘syslog_enabled’的成员
     if (server.syslog_enabled) syslog(syslogLevelMap[level], "%s", msg);
               ^
server.c: 在函数‘serverLog’中:
server.c:1076:30: 错误：‘struct redisServer’没有名为‘verbosity’的成员
     if ((level&0xff) < server.verbosity) return;
server.c: 在函数‘writeCommandsDeniedByDiskError’中:
server.c:3826:1: 警告：在有返回值的函数中，控制流程到达函数尾 [-Wreturn-type]
 }
 ^
server.c: 在函数‘iAmMaster’中:
server.c:5000:1: 警告：在有返回值的函数中，控制流程到达函数尾 [-Wreturn-type]
 }
 ^
make[1]: *** [server.o] 错误 1
make[1]: 离开目录“/usr/local/redis-6.0.6/src”
make: *** [all] 错误 2
```
解决方法：启用临时gcc9.3.1