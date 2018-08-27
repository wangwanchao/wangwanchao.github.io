---
title: spring bean分析
date: 2018-08-13 21:34:09
tags:
---
Spring的东西有很多不经常用，就会忘记，还是要多记录一下。其实bean这一块儿有很多的东西要梳理，以后慢慢还债


<!-- more -->

## bean生命周期 ##

1. 实例化BeanFactoryPostProcessor实现类; 
2. BeanFactoryPostProcessor#postProcessBeanFactory();
3. 实例化BeanPostProcessor实现类
4. 实例化InstantiationAwareBeanPostProcessorAdapter实现类
5. InstantiationAwareBeanPostProcessorAdapter#postProcessBeforeInstatiation()
6. bean构造器
6. InstantiationAwareBeanPostProcessorAdapter#postProcessPropertyValues()
7. bean设置属性值; 
8. 如果实现了BeanNameAware接口,调用setBeanName设置Bean的ID或者Name; 
9. 如果实现BeanFactoryAware接口,调用setBeanFactory 设置BeanFactory; 
10. 如果实现ApplicationContextAware,调用setApplicationContext设置ApplicationContext 
11. 调用BeanPostProcessor#postProcessBeforeInitialization(); 
12. 调用InitializingBean#afterPropertiesSet(); 
13. 调用bean属性中设置的init-method方法； 
14. 调用BeanPostProcessor#postProcessAfterInitialization();
15. InstantiationAwareBeanPostProcessorAdapter#postProcessAfterInstatiation()

DiposibelBean#destroy()
执行bean属性中设置的destroy-method方法



## 多bean加载顺序 ##
1. xml配置的bean优先于注解bean
2. 优先加载BeanPostProcessor实现的bean; 
3. 按bean文件(例如import标签)和bean的定义顺序装载,
4. 如果顺序执行中，beanA通过属性ref引用别的beanB，加载完beanA后，加载beanB，然后再顺序执行
5. 如果beanA属性中depen-on依赖beanB，则会优先装载beanB，然后装载beanA，然后顺序装载
6. BeanFactoryUtils类也会改变Bean的加载顺序