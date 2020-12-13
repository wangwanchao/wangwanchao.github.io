---
title: Spring的事务机制(5)
date: 2020-12-13 01:06:03
tags: 事务
categories: Spring
---
事务贯穿Spring、Mybatis、MySQL的整个阶段，包括现在的分布式事务。重新巩固一下，温故而知新是永恒的哲理。

<!--more -->
## Spring事务的5种隔离级别 ##
对应于数据库的隔离级别，用来解决脏读(未提交读)、不可重复读、幻读一系列问题，常用的数据库MySQL有4种隔离级别。而Spring既可以使用数据库默认的隔离级别，也可以自定义。
1. ISOLATION_DEFAULT: **PlatfromTransactionManager默认的隔离级别**，使用后端数据库默认的事务隔离级别。另外四个与JDBC的隔离级别相对应。MySQL默认使用REPEATABLE_READ，Oracle默认采用READ_COMMITED
2. ISOLATION_READ_UNCOMMITTED: 这是事务最低的隔离级别，它充许另外一个事务可以看到这个事务未提交的数据。这种隔离级别会产生脏读，不可重复读和幻像读。
3. ISOLATION_READ_COMMITTED: 保证一个事务修改的数据提交后才能被另外一个事务读取。另外一个事务不能读取该事务未提交的数据。**可以防止脏读**
4. ISOLATION_REPEATABLE_READ: 事务隔离级别可以防止脏读，不可重复读。但是可能出现幻像读。
5. ISOLATION_SERIALIZABLE: 花费最高代价但是最可靠的事务隔离级别。事务被处理为顺序执行。

## Spring事务的7种传播机制 ##
传播机制也就是在多个事务之间调用，调用链后续事务是否处于前序的事务中，以及如果出现异常如何处理完整事务链的提交、回滚。
TransactionDefinition接口中定义了7种类型的事务传播机制：
1. REQUIRED: 支持当前事务，如果当前没有事务，就新建一个事务。**这是最常见的选择，也是 Spring 默认的事务的传播**。
2. REQUIRES_NEW: 新建事务，如果当前存在事务，把当前事务挂起。新建的事务将和被挂起的事务没有任何关系，是两个独立的事务，**外层事务失败回滚之后，不能回滚内层事务执行的结果**，内层事务失败抛出异常，外层事务捕获，也可以不处理回滚操作
3. SUPPORTS: 支持当前事务，如果当前没有事务，就以非事务方式执行。
4. MANDATORY: 支持当前事务，如果当前没有事务，就抛出异常。
5. NOT_SUPPORTED: 以非事务方式执行操作，如果当前存在事务，就把当前事务挂起。
6. NEVER: 以非事务方式执行，如果当前存在事务，则抛出异常。
7. NESTED: 嵌套事务，如果当前存在事务，则创建一个事务作为当前事务的嵌套事务来运行；如果当前没有事务，就新建一个事务，此时类似于TransactionDefinition.PROPAGATION_REQUIRED。

## Spring事务原理
事务是基于连接(connection)的，不能跨连接进行事务管理。
Spring事务基于AOP实现，创建、获取connection连接，`TransactionSynchronizationManager`通过ThreadLocal将connection、sqlSession和当前事务绑定，`SqlSessionFactory`用于创建`SqlSession`会话，
1. 在调用事务方法时，首先会进入拦截器`TransactionInterceptor`
2. 创建事务，
3. 开启事务，从数据源获取一个连接，设置'事务同步'，同时设置事务状态
4. 在事务中，需要创建不同`SqlSessionFactory`bean、重写Mybatis中原有的`sqlSessionTemplate`bean
5. 执行sql

## Spring事务配置
TransactionDefinition类定义了事务属性，可以看到隔离级别、传播机制、超时时间、只读属性。
```
public interface TransactionDefinition{
    int getIsolationLevel();
    int getPropagationBehavior();
    int getTimeout();
    boolean isReadOnly();
}
```
`ReadOnly`这个属性只是用来提高事务处理的性能。

### 编程式事务
管控粒度小，可实现代码块级别的事务，需要手动编写代码执行提交、回滚。
#### 基于PlatformTransactionManager、TransactionDefinition 和 TransactionStatus最底层的接口实现
这是最底层的接口。

#### 基于TransactionTemplate实现
`TransactionTemplate`还是基于底层`PlatformTransactionManager`。`PlatformTransactionManager`根据不同的ORM有不同的实现类：
> DataSourceTransactionManager：适用于使用JDBC和iBatis进行数据持久化操作的情况。
> HibernateTransactionManager：适用于使用Hibernate进行数据持久化操作的情况。
> JpaTransactionManager：适用于使用JPA进行数据持久化操作的情况。
> 另外还有JtaTransactionManager 、JdoTransactionManager、> JmsTransactionManager等等。

### 声明式事务
侵入小，事务由Spring管理，底层建立在AOP基础上，本质上还是对方法进行拦截，根据执行结果进行提交、回滚。缺点就是只能作用到方法级别，无法像编程式事务一样做到代码级别的控制。
即便是声明式事务也有以下几种不同的实现，前两种比较底层，

#### 基于TransactionInterceptor实现

#### 基于TransactionProxyFactoryBean实现

#### 基于tx和aop命名空间实现
这是Spring时代比较常用的实现方法。

#### 基于@Transactional注解实现
这是一种SpringBoot当下最常见的使用方法，但是也有一些注意事项，否则会导致事务失效。以下是Transactional注解：
```
public @interface Transactional {
    @AliasFor("transactionManager")
    String value() default "";

    @AliasFor("value")
    String transactionManager() default "";

    Propagation propagation() default Propagation.REQUIRED;

    Isolation isolation() default Isolation.DEFAULT;

    int timeout() default -1;

    boolean readOnly() default false;

    Class<? extends Throwable>[] rollbackFor() default {};

    String[] rollbackForClassName() default {};

    Class<? extends Throwable>[] noRollbackFor() default {};

    String[] noRollbackForClassName() default {};
}
```

### 同步机制
核心类
`TransactionSynchronizationManager`用来控制事务同步器`TransactionSynchronization`，
`TransactionSynchronization`：事务同步器，可以按序定义同步器
`DataSourceUtils`：用来管理连接connection，
`TransactionStatus`：用来管理事务的状态，

### 监听机制

## MyBatis事务

### JdbcTransaction模式

### ManagedTraction模式

## 多数据源
步骤：
1. 创建多个数据源DataSource，ds1 和 ds2；
2. 将ds1 和 ds2 数据源放入动态数据源DynamicDataSource；
3. 将DynamicDataSource注入到SqlSessionFactory。
4. 在事务中，需要创建不同的`SqlSessionFactory`bean、重写Mybatis中原有的`sqlSessionTemplate`bean

## Spring事务失效的情况 ##

1. MySQL数据表的引擎必须为InnoDB，MyISAM引擎不支持事务; static事务方法失效; 在controller层调用失效; catch异常不处理

2. 调用的类必须是由Spring容器管理的代理类

jdk代理
cglib代理

3. 调用的方法必须是public方法，这是由Spring的AOP特性决定的。
Spring的AOP是通过CGlibAopProxy和JdkDynamicAopProxy动态代理实现的，在对方法进行拦截前后AbstractFallbackTransactionAttributeSource#computeTransactionAttribute会检查目标方法是否是public。
这样修饰符可以有两种选择：
private: 使用@Transactional注解编译报错`Methods annotated with @Transactional must be overridable`
protected: 事务不生效
public: 必须在接口内，如果在controller内，事务不生效

4. 抛出runtimeException异常才能回滚。

默认情况下，事务抛出未检查异常、Error才回滚，如果是已检查异常则不回滚。
如果需要checked Exception回滚，注解需要标明@Transactional(rollbackFor=Exception.class)，或者try-catch后throw new RuntimeException

5. 事务传播策略在内部方法调用时(自调用问题)
这是因为在AOP代理下，只有目标方法由外部调用时，目标方法才会由Spring生成的代理对象来管理。
### 情景1：
```
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
```

### 情景2：
```
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
```

### 解决方案1：

> 增加<aop:config proxy-target-class="true" expose-proxy="true"></aop:config>
> 
> 在外层调用内层的事务方法时使用AopContext代理 
```
@Transactional(propagation = Propagation.REQUIRED)
@Override
public void insert(Person person, Book book){
    ((PersonServiceImpl)AopContext.currentProxy()).insert2(person, book);
}
```

### 解决方案2：

> 在外层调用内层的事务方法时使用Spring的IOC容器代理 
``` 	
@Autowired
private ApplicationContext ctx;

@Transactional(propagation = Propagation.REQUIRED)
@Override
public void insert(Person person, Book book){
    ctx.getBean(PersonServiceImpl.class).insert2(person, book);;
}
```
### 解决方案3：

> 注入自身类
```
@Autowired
private BookService bookService;

@Transactional(propagation = Propagation.REQUIRED)
@Override
public void insert(Person person, Book book){
    bookService.insert2(person, book);;
}
```