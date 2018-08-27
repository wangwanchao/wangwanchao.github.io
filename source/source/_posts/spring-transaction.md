---
title: Spring的事务机制
date: 2018-08-07 01:06:03
tags: spring, 事务
categories: spring
---
## 事务的7种传播机制 ##

TransactionDefinition接口中定义了7种类型的事务传播机制：

PROPAGATION_REQUIRED: 支持当前事务，如果当前没有事务，就新建一个事务。**这是最常见的选择，也是 Spring 默认的事务的传播**。

PROPAGATION_REQUIRES_NEW: 新建事务，如果当前存在事务，把当前事务挂起。新建的事务将和被挂起的事务没有任何关系，是两个独立的事务，外层事务失败回滚之后，不能回滚内层事务执行的结果，内层事务失败抛出异常，外层事务捕获，也可以不处理回滚操作

PROPAGATION_SUPPORTS: 支持当前事务，如果当前没有事务，就以非事务方式执行。

PROPAGATION_MANDATORY: 支持当前事务，如果当前没有事务，就抛出异常。

PROPAGATION_NOT_SUPPORTED: 以非事务方式执行操作，如果当前存在事务，就把当前事务挂起。

PROPAGATION_NEVER: 以非事务方式执行，如果当前存在事务，则抛出异常。

PROPAGATION_NESTED   

<!--more -->

## 事务的4种隔离级别 ##

ISOLATION_DEFAULT: **PlatfromTransactionManager默认的隔离级别**，使用数据库默认的事务隔离级别。另外四个与 JDBC 的隔离级别相对应。

ISOLATION_READ_UNCOMMITTED: 这是事务最低的隔离级别，它充许另外一个事务可以看到这个事务未提交的数据。这种隔离级别会产生脏读，不可重复读和幻像读。

ISOLATION_READ_COMMITTED: 保证一个事务修改的数据提交后才能被另外一个事务读取。另外一个事务不能读取该事务未提交的数据。可以防止脏读

ISOLATION_REPEATABLE_READ: 事务隔离级别可以防止脏读，不可重复读。但是可能出现幻像读。

ISOLATION_SERIALIZABLE: 花费最高代价但是最可靠的事务隔离级别。事务被处理为顺序执行。

## 事务失效的情况 ##

1、MySQL数据表的引擎必须为InnoDB，MyISAM引擎不支持事务

2、调用的类必须是由Spring容器管理的代理类

jdk代理

cglib代理

3、调用的方法必须是public方法，这是由Spring的AOP特性决定的

4、抛出runtimeException才能回滚。

事务默认支持CheckException不会滚，unCheckException回滚，如果需要checkException回滚，注解需要标明@Transactional(rollbackFor=Exception.class)

5、事务传播策略在内部方法调用时将不起作用

情景1：

	public void insert2(Person person, Book book){
        insert(person, book);
    }

    @Transactional
    public void insert(Person person, Book book){
        insertPerson(person);

        insertBook(book);
    }
	
	personServiceImpl.insert(person, book)事务起作用

	personServiceImpl.insert2(person, book)事务不起作用

解决方案1：

> 增加<aop:config proxy-target-class="true" expose-proxy="true"></aop:config>
> 
> 在外层调用内层的事务方法时使用AopContext代理 
  
	public void insert2(Person person, Book book){
        ((PersonServiceImpl)AopContext.currentProxy()).insert(person, book);
    }

解决方案2：

> 增加<aop:config proxy-target-class="true"></aop:config>
> 
> 在外层调用内层的事务方法时使用Spring的IOC容器代理 
  	
	@Autowired
    private ApplicationContext ctx;

	public void insert2(Person person, Book book){
        ctx.getBean(PersonServiceImpl.class).insert(person, book);;
    }