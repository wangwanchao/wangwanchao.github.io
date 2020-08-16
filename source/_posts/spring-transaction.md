---
title: Spring的事务机制(5)
date: 2018-08-07 01:06:03
tags: Spring, 事务
categories: Spring
---
## 事务的7种传播机制 ##

TransactionDefinition接口中定义了7种类型的事务传播机制：

1. REQUIRED: 支持当前事务，如果当前没有事务，就新建一个事务。**这是最常见的选择，也是 Spring 默认的事务的传播**。

2. REQUIRES_NEW: 新建事务，如果当前存在事务，把当前事务挂起。新建的事务将和被挂起的事务没有任何关系，是两个独立的事务，**外层事务失败回滚之后，不能回滚内层事务执行的结果**，内层事务失败抛出异常，外层事务捕获，也可以不处理回滚操作

3. SUPPORTS: 支持当前事务，如果当前没有事务，就以非事务方式执行。

4. MANDATORY: 支持当前事务，如果当前没有事务，就抛出异常。

5. NOT_SUPPORTED: 以非事务方式执行操作，如果当前存在事务，就把当前事务挂起。

6. NEVER: 以非事务方式执行，如果当前存在事务，则抛出异常。

7. NESTED: 嵌套事务

<!--more -->

## 事务的5种隔离级别 ##

1. ISOLATION_DEFAULT: **PlatfromTransactionManager默认的隔离级别**，使用后端数据库默认的事务隔离级别。另外四个与JDBC的隔离级别相对应。MySQL默认使用REPEATABLE_READ，Oracle默认采用READ_COMMITED

2. ISOLATION_READ_UNCOMMITTED: 这是事务最低的隔离级别，它充许另外一个事务可以看到这个事务未提交的数据。这种隔离级别会产生脏读，不可重复读和幻像读。

3. ISOLATION_READ_COMMITTED: 保证一个事务修改的数据提交后才能被另外一个事务读取。另外一个事务不能读取该事务未提交的数据。**可以防止脏读**

4. ISOLATION_REPEATABLE_READ: 事务隔离级别可以防止脏读，不可重复读。但是可能出现幻像读。

5. ISOLATION_SERIALIZABLE: 花费最高代价但是最可靠的事务隔离级别。事务被处理为顺序执行。

## 事务失效的情况 ##

1、MySQL数据表的引擎必须为InnoDB，MyISAM引擎不支持事务; static事务方法失效; 在controller层调用失效; catch异常不处理

2、调用的类必须是由Spring容器管理的代理类

jdk代理

cglib代理

3、调用的方法必须是public方法，这是由Spring的AOP特性决定的。

这样修饰符可以有两种选择：
private: 使用@Transactional注解编译报错`Methods annotated with @Transactional must be overridable`

protected: 事务不生效

public: 必须在接口内，如果在controller内，事务不生效


4、抛出runtimeException才能回滚。

事务默认支持checked Exception不回滚，unCheckException回滚。
如果需要checked Exception回滚，注解需要标明@Transactional(rollbackFor=Exception.class)，或者try-catch后throw new RuntimeException

5、事务传播策略在内部方法调用时(自调用问题)

情景1：

	@Override
	public void insert(Person person, Book book){
        insert(person, book);
    }

	@Override
    @Transactional
    public void insert2(Person person, Book book){
        insertPerson(person);

        insertBook(book);
    }
	
	// 调用
	personServiceImpl.insert(person, book)事务不起作用

	personServiceImpl.insert2(person, book)事务起作用

情景2：

	@Override
    @Transactional(propagation = Propagation.REQUIRED)
	public void insert(Person person, Book book){
        insert(person, book);
    }

	@Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void insert2(Person person, Book book){
        insertPerson(person);

        insertBook(book);
    }
	
	// 调用
	personServiceImpl.insert(person, book)事务起作用

	personServiceImpl.insert2(person, book)事务不起作用

解决方案1：

> 增加<aop:config proxy-target-class="true" expose-proxy="true"></aop:config>
> 
> 在外层调用内层的事务方法时使用AopContext代理 
  
	@Transactional(propagation = Propagation.REQUIRED)
    @Override
	public void insert(Person person, Book book){
        ((PersonServiceImpl)AopContext.currentProxy()).insert2(person, book);
    }

解决方案2：

> 在外层调用内层的事务方法时使用Spring的IOC容器代理 
  	
	@Autowired
    private ApplicationContext ctx;

	@Transactional(propagation = Propagation.REQUIRED)
    @Override
	public void insert(Person person, Book book){
        ctx.getBean(PersonServiceImpl.class).insert2(person, book);;
    }

解决方案3：

> 注入自身类
  	
	@Autowired
    private BookService bookService;

	@Transactional(propagation = Propagation.REQUIRED)
    @Override
	public void insert(Person person, Book book){
        bookService.insert2(person, book);;
    }