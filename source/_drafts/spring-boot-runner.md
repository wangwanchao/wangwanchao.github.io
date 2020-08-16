---
title: SpringBoot的启动类
date: 2019-01-17 13:55:39
tags: SpringBoot
categpries: SpringBoot
---
项目启动之前，可以有一些初始化动作：读取配置文件、数据库连接。SpringBoot提供了两个接口：'CommandLineRunner'和'ApplicationRunner'，通过'@Order'注解定义启动顺序

<!-- more -->

## CommandLineRunner


```
@Component
@Order(10)
@Slf4j
public class ApplicationStartup implements CommandLineRunner {

   @Autowired
   private DataService dataService;
   
	@Override
	public void run(String... args) throws Exception {
		return;
	}
}

```



## ApplicationRunner
该接口的run方法参数是一个ApplicationArguments类

```
@Component
@Order(10)
@Slf4j
public class AppApplicationStartup implements ApplicationRunner {

    @Autowired
    private AppPushService appPushService;

    @Override
    public void run(ApplicationArguments args) throws Exception {
        /**
         * 定时推送消息
         */
        appPushService.pushSimplePayload();
    }
}

```