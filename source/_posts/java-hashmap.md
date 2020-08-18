---
title: java集合之HashMap
date: 2018-08-09 17:26:39
tags: 集合
categories: Java
---
hasmap在jdk1.7和jdk1.8中做了很大的改进，

<!-- more -->

## put(K, V)方法 ##
	public V put(K key, V value) {
        if (table == EMPTY_TABLE) {
            inflateTable(threshold);
        }
        if (key == null)
            return putForNullKey(value);
		// 先对map做一次查找，查看是否包含该元组，如果存在，则直接返回
        int hash = hash(key);
        // 返回 h & (table.length-1)
        int i = indexFor(hash, table.length);
        for (Entry<K,V> e = table[i]; e != null; e = e.next) {
            Object k;
            if (e.hash == hash && ((k = e.key) == key || key.equals(k))) {
                V oldValue = e.value;
                e.value = value;
                e.recordAccess(this);
                return oldValue;
            }
        }
		// 每次对map修改一次，modCount加1
        modCount++;
		// i：bucketIndex
        addEntry(hash, key, value, i);
        return null;
    }
	
	// 添加
	void addEntry(int hash, K key, V value, int bucketIndex) {
        if ((size >= threshold) && (null != table[bucketIndex])) {
			//自动扩容，并重新哈希
            resize(2 * table.length);
            hash = (null != key) ? hash(key) : 0;
            bucketIndex = indexFor(hash, table.length);
        }

        createEntry(hash, key, value, bucketIndex);
    }

	// 在冲突链表头部插入新的entry
    void createEntry(int hash, K key, V value, int bucketIndex) {
        Entry<K,V> e = table[bucketIndex];
        table[bucketIndex] = new Entry<>(hash, key, value, e);
        size++;
    }

	static class Entry<K,V> implements Map.Entry<K,V> {
        final K key;
        V value;
        Entry<K,V> next;
        int hash;

		...
	}

可以看到先通过hash(key)和table.length求得一个下标i，然后去遍历table[i]后面的Entry<K,V>链表,查找是否已经存储过该对象，如果存储过，则返回存储的e.value，并且重新赋值新的value；否则添加Entry

扩容机制可以看到，如果size > threshold，则执行resize(2 * table.length)，

1. 在new HashMap()中默认threashold = DEFAULT_INITIAL_CAPACITY=16，否则为自定义值
2. 在put(K,V)的时候先执行了inflateTable(threshold)，inflateTable中int capacity = roundUpToPowerOf2(toSize)，
3. 所以inflateTable后现在threshold = capacity*0.75；

同时可以看到在createEntry中size++，即当元素个数>=0.75capacity时，扩容为2table.length = 2capacity

	private void inflateTable(int toSize) {
        // Find a power of 2 >= toSize
        int capacity = roundUpToPowerOf2(toSize);

        threshold = (int) Math.min(capacity * loadFactor, MAXIMUM_CAPACITY + 1);
        table = new Entry[capacity];
        initHashSeedAsNeeded(capacity);
    }

	private static int roundUpToPowerOf2(int number) {
        // assert number >= 0 : "number must be non-negative";
        return number >= MAXIMUM_CAPACITY
                ? MAXIMUM_CAPACITY
                : (number > 1) ? Integer.highestOneBit((number - 1) << 1) : 1;
    }

	
## resize(int)方法 ##

	void resize(int newCapacity) {
        Entry[] oldTable = table;
        int oldCapacity = oldTable.length;
            threshold = Integer.MAX_VALUE;
            if (oldCapacity == MAXIMUM_CAPACITY) {
            return;
        }

        Entry[] newTable = new Entry[newCapacity];
		
		// 扩容后进行重hash操作
        transfer(newTable, initHashSeedAsNeeded(newCapacity));
        table = newTable;
        threshold = (int)Math.min(newCapacity * loadFactor, MAXIMUM_CAPACITY + 1);
    }

	void transfer(Entry[] newTable, boolean rehash) {
        int newCapacity = newTable.length;
		
		// 遍历元素重hash
        for (Entry<K,V> e : table) {
            while(null != e) {
                Entry<K,V> next = e.next;
                if (rehash) {
                    e.hash = null == e.key ? 0 : hash(e.key);
                }
                int i = indexFor(e.hash, newCapacity);
                e.next = newTable[i];
                newTable[i] = e;
                e = next;
            }
        }
    }

可以看到在resize后，要对所有的元素重hash进行存储

## get(Object) ##

	public V get(Object key) {
        if (key == null)
            return getForNullKey();
        Entry<K,V> entry = getEntry(key);

        return null == entry ? null : entry.getValue();
    }

	final Entry<K,V> getEntry(Object key) {
        if (size == 0) {
            return null;
        }

		//先通过hash()函数得到key对应buckets的下标，然后依次遍历冲突链表
        int hash = (key == null) ? 0 : hash(key);
        for (Entry<K,V> e = table[indexFor(hash, table.length)];
             e != null;
             e = e.next) {
            Object k;
            if (e.hash == hash &&
                ((k = e.key) == key || (key != null && key.equals(k))))
                return e;
        }
        return null;
    }
可以看到其实查找元素就是先通过hash(key)定位到数组，然后再去遍历数组后的链表

## containsKey(Object) ##

	public boolean containsKey(Object key) {
        return getEntry(key) != null;
    }

可以看到其实containsKey(Object)走的也是一个get(Object)

## size() ##

	public int size() {
        return size;
    }
可以看到HashMap查找长度，其实就是返回了一个属性，Java集合中大多都是返回size属性，不同的是ConcurrentHashMap需要实时去查找。因为ConcurrentHashMap是线程安全的

## hash冲突 ##


## 负载因子 ##

加载因子越大,填满的元素越多,好处是,空间利用率高了,但冲突的机会加大了。链表长度会越来越长,查找效率降低。

反之,加载因子越小,填满的元素越少,好处是:冲突的机会减小了,但空间浪费多了。表中的数据将过于稀疏（很多空间还没用，就开始扩容了）

## 特性 ##

1. key、value都允许为null值


