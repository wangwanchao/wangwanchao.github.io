---
title: Hash算法求固定值
date: 2020-09-19 10:52:19
tags:
categpries: Math
mathjax: true
---
昨天在工作中遇到一个问题，大致场景是这样的：
1. 对象包括id(固定)、total、count(递增)
2. 不同的对象根据count求出指定范围内的固定随机值mock
3. 该值需要满足一下条件：
  > 每个对象在第一次随机后每次该随机值mock不变
  > 不同的对象计算第一次随机值后，如果count、total不变，mock值不变
  > 不同对象的mock值在total的0.1～0.5内浮动

当时只能想到怎么用Random来做，毫无思路。组长10分钟内连测试用例都验证过了。这算是真实感受到智商的暴击和数学的用处。直接上代码

<!-- more -->
```
public static int mock(String id, int count, int total) {
    int min = Integer.max(total / 9 - count, 0);
    int max = Integer.max(total - count, 0);
    if (max <= min) {
      return count;
    }
    int mock = Math.abs(id.hashCode()) % 100 * (max - min) / 100 + min;
    return mock + count;
  }
```
思路：
