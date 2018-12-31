---
title: spring-autowired-resource-service
date: 2018-12-21 00:53:37
tags:
categpries:
---

## @Autowired ##
byType注入，


## @Resource ##
默认byName注入，有两个属性：name、type，可以自由定义

注解 @Resource 的装配顺序：

1. 如果同时指定了 name 和 type，则从 Spring 上下文中找到唯一匹配的 bean 进行装配，找不到则抛出异常； 
2. 如果指定了 name，则从上下文中查找名称（id）匹配的 bean 进行装配，找不到则抛出异常；
3. 如果指定了 type，则从上下文中找到类型匹配的唯一 bean 进行装配，找不到或者找到多个，都会抛出异常；
4. 如果既没有指定 name，又没有指定 type，则自动按照 byName 方式进行装配；如果没有匹配，则回退为一个原始类型进行匹配，如果匹配成功，则进行自动装配。


### 约定 ###

@Service，用于标注业务层组件（通常定义的 Service 层就用这个注解）；
@Controller，用于标注控制层组件（如 Struts 中的 action）；
@Repository，用于标注数据访问组件，即 DAO 层组件；
@Component，泛指组件，当组件不好归类的时候，咱们就可以用这个注解进行标注。
