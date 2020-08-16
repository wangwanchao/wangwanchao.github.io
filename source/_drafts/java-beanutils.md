---
title: BeanUtils工具类
date: 2018-12-25 22:50:27
tags: Java
categpries: Java
---
BeanUtils和PropertyUtils

<!-- more -->

```
org.springframework.beans.BeanUtils.copyProperties(src, dest);

```

```
org.apache.commons.beanutils.BeanUtils.copyProperties(src, dest);
```

```
org.apache.commons.beanutils.BeanUtilsBean.getInstance().copyProperties(src, dest);
```

```
org.apache.commons.beanutils.PropertyUtils.copyProperties(src, dest);
```


## BeanUtils和PropertyUtils的区别

1. beanutils支持name相同、类型兼容的属性转换；propertyutils仅支持name相同、类型相同的属性转换
2. beanutils对部分属性不支持null的转换；propertyutils支持null的转换

3. 对于Long和Date类型的转换，BeanUtils转换正常；PropertyUtils报错
4. 自定义的对象属性类型，都是浅拷贝
5. BeanUtils支持自定义Converter接口，PropertyUtils没有