---
title: java注解
date: 2018-08-13 19:33:36
tags: java, annotation
categories: java
---
Spring Boot封装了很多的注解类，所以回顾一下注解

## java内置注解 ##

### 3种标准注解： ###

@Override

@Desprecated

@Suppress Warnings

<!-- more -->

### 4种元注解： ###

@Target: 表示注解用于什么地方

	ElementType.CONSTRUCTOR
	ElementType.FIELD
	ElementType.LOCAL_VARIABLE
	ElementType.METHOD
	ElementType.PACKAGE
	ElementType.PARAMETER
	ElementType.TYPE

@Retention: 表示需要在什么级别保存该注解信息
	
	RetentionPolicy.SOURCE
	RetentionPolicy.CLASS
	RetentionPolicy.RUNTIME

@Documented: 将此注解包含在Javadoc中

@Inherited: 允许子类继承父类中的注解

标记注解：没有元素的注解

例如：

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	public @interface Test{}


注解元素的种类：

> 所有基本类型
> 
> String
> 
> Class
> 
> enum
> 
> Annotation
> 
> 以上所有类型的数组


**注意:**不允许使用任何包装类型

注解的一些默认规则：

1、元素不能有不确认的值

2、对于非基本类型的值，无论在源代码中声明，或者在注解接口中定义默认值都不能以null作为其值

例如：

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	public @interface Test{
		public int id() default -1;
		public String description() default "";
	}

### 注解嵌套：注解作为注解的元素 ###

例如：
	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	public @interface Test{
		public int id() default -1;
		public String description() default "";
	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	public @interface Test2{
		public int sid() default -1;
		public Test test() default @Test;
	}
	
	@Test2(sid = 10, test = @Test(description="test"))
	String testAnnotation;

### 组合注解：注解上除了元注解，还会有其他的注解 ###

例如：

	@Target(ElementType.TYPE)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Inherited
	@SpringBootConfiguration
	@EnableAutoConfiguration
	@ComponentScan(excludeFilters = {
		@Filter(type = FilterType.CUSTOM, classes = TypeExcludeFilter.class),
		@Filter(type = FilterType.CUSTOM, classes = AutoConfigurationExcludeFilter.class) })
	public @interface SpringBootApplication {
		...
	}

可以看到SpringBootApplication注解除了元注解，还有@SpringBootConfiguration、@EnableAutoCOnfiguration、@ComponentScan注解


### 条件注解 ###