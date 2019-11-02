---
title: 求一个数组中重复出现次数最多的数字以及出现次数
date: 2018-08-14 11:00:24
tags: algorithms, java, go
categories: Algorithms
---
## java语言实现 ##

时间复杂度：O(n)

空间复杂度：O(n)

<!-- more -->

	public static void main(String[] args){  
        int[] arr = { 7, 1, 3, 5, 4, 6, 6, 8, 8, 9, 2, 8, 3 , 8};

        Map<Integer, Integer> map = new HashMap<>();
        for(int i=0; i < arr.length; i++) {
            if(map.containsKey(arr[i])) {
                map.put(arr[i], map.get(arr[i]) + 1);
            } else {
                map.put(arr[i], 1);
            }
        }

        int count = -1;
        int max = Integer.MIN_VALUE;
        Iterator<Map.Entry<Integer, Integer>> iter = map.entrySet().iterator();
        while(iter.hasNext()){
            Map.Entry<Integer, Integer> entry = iter.next();
            if(entry.getValue() > count) {
                count = entry.getValue();
                max = entry.getKey();
            }
        }

        System.out.println("出现次数最多的元素：" + max +"--出现次数：" + count);
    }

## go语言实现 ##

时间复杂度：O(n)

空间复杂度：O(n)

	package main
	
	import (
		"fmt"
	)
	
	func main() {
		arr := []int{ 7, 1, 3, 5, 4, 6, 6, 8, 8, 9, 2, 8, 3 , 8}
	
		// 创建map类型key(数值)--value(出现次数)
		maps := make(map[int]int)
		for _, v := range arr {
			if maps[v] != 0 {
				maps[v]++
			} else {
				maps[v] = 1
			}
		}
	
		max, count := maxInMap(maps)
	
		fmt.Printf("出现次数最多的数字： %d， 次数： %d", max, count)
	}
	
	func maxInMap(maps map[int]int) (int, int) {
		count := -1
		var max int 
		for k, v := range maps {
			if v > count {
				count = v
				max = k
			}
		}
	
		return max, count
	}