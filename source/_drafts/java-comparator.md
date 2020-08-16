---
title: java集合Comparator和Comparable
date: 2018-09-10 22:15:58
tags: java
categories: java
---

看了一些博客，自己也想了一下，但总是想不出有明显区别的地方，还是理解的不深刻。

## Comparable ##

Comparable是一个排序接口。如果一个类实现了Comparable接口，则说明该类可以实现排序。String、Integer、Double都默认实现了Comparable接口。

	public interface Comparable<T> {
	    
	    public int compareTo(T o);
	}


## Comparator ##

Comparator是比较器接口

	public interface Comparator<T> {
	    
	    int compare(T o1, T o2);
	
	    boolean equals(Object obj);
	}


