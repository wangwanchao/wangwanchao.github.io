---
title: java集合之ArrayList和LinkedList
date: 2018-08-15 18:15:54
tags: java, 集合
categories: java
---
集合的东西是很常用的类，今天抽时间看看源码，加深印象

<!-- more -->

# ArrayList #

可以看到ArrayList的默认初始化大小为10，

	private static final int DEFAULT_CAPACITY = 10;

## 插入元素 ##

### add(E e) ###

	public boolean add(E e) {
		// 扩容机制，
        ensureCapacityInternal(size + 1);  // Increments modCount!!
		
		// 直接在数组末尾插入元素
        elementData[size++] = e;
        return true;
    }
	
	// 扩容
	private void ensureCapacityInternal(int minCapacity) {
        if (elementData == DEFAULTCAPACITY_EMPTY_ELEMENTDATA) {
            minCapacity = Math.max(DEFAULT_CAPACITY, minCapacity);
        }

        ensureExplicitCapacity(minCapacity);
    }

	private void ensureExplicitCapacity(int minCapacity) {
        modCount++;

        // overflow-conscious code
        if (minCapacity - elementData.length > 0)
            grow(minCapacity);
    }

	private void grow(int minCapacity) {
        // overflow-conscious code
        int oldCapacity = elementData.length;
        int newCapacity = oldCapacity + (oldCapacity >> 1);
        if (newCapacity - minCapacity < 0)
            newCapacity = minCapacity;
        if (newCapacity - MAX_ARRAY_SIZE > 0)
            newCapacity = hugeCapacity(minCapacity);
        // minCapacity is usually close to size, so this is a win:
        elementData = Arrays.copyOf(elementData, newCapacity);
    }

	
### add(int index, E element) ###

	public void add(int index, E element) {
        rangeCheckForAdd(index);

        ensureCapacityInternal(size + 1);  // Increments modCount!!
        System.arraycopy(elementData, index, elementData, index + 1,
                         size - index);
        elementData[index] = element;
        size++;
    }

可以看到在指定位置index插入元素的时候才会导致元素的移动

## 查找元素 ##

	public E get(int index) {
        rangeCheck(index);

        return elementData(index);
    }

	@SuppressWarnings("unchecked")
    E elementData(int index) {
        return (E) elementData[index];
    }

时间复杂度为O(1)

## 删除元素 ##

### remove(int index) ###

	public E remove(int index) {
        rangeCheck(index);

        modCount++;
        E oldValue = elementData(index);
        
        // 向前移动的元素的位置
        int numMoved = size - index - 1;
        if (numMoved > 0)
            System.arraycopy(elementData, index+1, elementData, index,
                             numMoved);
        elementData[--size] = null; // clear to let GC do its work

        return oldValue;
    }
	
	// 原生方法
	public static native void arraycopy(Object src,  int  srcPos,
                                        Object dest, int destPos,
                                        int length);

可以看到删除指定index的元素后，后面的所有元素向前移动。时间复杂度为O(n)

### remove(Object o) ###

	public boolean remove(Object o) {
        if (o == null) {
            for (int index = 0; index < size; index++)
                if (elementData[index] == null) {
                    fastRemove(index);
                    return true;
                }
        } else {
            for (int index = 0; index < size; index++)
                if (o.equals(elementData[index])) {
                    fastRemove(index);
                    return true;
                }
        }
        return false;
    }

	private void fastRemove(int index) {
        modCount++;
        int numMoved = size - index - 1;
        if (numMoved > 0)
            System.arraycopy(elementData, index+1, elementData, index,
                             numMoved);
        elementData[--size] = null; // clear to let GC do its work
    }

删除指定对象Object的元素，也会导致后面的元素向前移动，只不过中间多了对象的比较过程，时间复杂度为O(n)


# LinkedList #

## 插入元素 ##

### add(E e) ###

	// 在链表末尾插入元素
    public boolean add(E e) {
        linkLast(e);
        return true;
    }
	
	// 尾插法
	void linkLast(E e) {
        final Node<E> l = last;
        final Node<E> newNode = new Node<>(l, e, null);
        last = newNode;
        if (l == null)
			//初始链表为空，这是插入第一个元素
            first = newNode;
        else
            l.next = newNode;
        size++;
        modCount++;
    }
插入元素默认为尾插法，所以时间复杂度为O(1)

### add(int index, E element) ###
	public void add(int index, E element) {
		// 检查插入位置是否合法
        checkPositionIndex(index);

        if (index == size)
			// 插入位置是末尾，包括列表为空的情况
            linkLast(element);
        else
            linkBefore(element, node(index));
    }

	void linkBefore(E e, Node<E> succ) {
        // 先根据index找到要插入的位置，再修改引用，完成插入操作
        final Node<E> pred = succ.prev;
        final Node<E> newNode = new Node<>(pred, e, succ);
        succ.prev = newNode;
		// 插入位置为0，即插入第一个节点
        if (pred == null)
            first = newNode;
        else
            pred.next = newNode;
        size++;
        modCount++;
    }
如果指定index，仍然需要去遍历链表，时间复杂度为O(n)

## 修改元素 ##

	public E set(int index, E element) {
        checkElementIndex(index);
		
		// 先找到指定位置节点
        Node<E> x = node(index);
        E oldVal = x.item;
        x.item = element;
		
		// 修改元素后返回旧值
        return oldVal;
    }
修改元素也是先找到节点，然后修改value，时间复杂度为O(n)

## 查找元素 ##
	
	public E get(int index) {
        checkElementIndex(index);
        return node(index).item;
    }
	
	// 因为链表是双向的，具体从开始往后找还是从后往前找需要判断
	Node<E> node(int index) {
        // assert isElementIndex(index);

        if (index < (size >> 1)) {
            Node<E> x = first;
            for (int i = 0; i < index; i++)
                x = x.next;
            return x;
        } else {
            Node<E> x = last;
            for (int i = size - 1; i > index; i--)
                x = x.prev;
            return x;
        }
    }

查找index的元素，需要遍历链表，时间复杂度为O(n)

## 删除元素 ##

### remove(int index) ###

	public E remove(int index) {
        checkElementIndex(index);
        return unlink(node(index));
    }

	E unlink(Node<E> x) {
        // assert x != null;
        final E element = x.item;
        final Node<E> next = x.next;
        final Node<E> prev = x.prev;

        if (prev == null) {
            first = next;
        } else {
            prev.next = next;
            x.prev = null;
        }

        if (next == null) {
            last = prev;
        } else {
            next.prev = prev;
            x.next = null;
        }

        x.item = null;
        size--;
        modCount++;
        return element;
    }

### remove(Object o) ###

	public boolean remove(Object o) {
        if (o == null) {
            for (Node<E> x = first; x != null; x = x.next) {
                if (x.item == null) {
                    unlink(x);
                    return true;
                }
            }
        } else {
            for (Node<E> x = first; x != null; x = x.next) {
                if (o.equals(x.item)) {
                    unlink(x);
                    return true;
                }
            }
        }
        return false;
    }

可以看到删除元素，也会先遍历查找到节点，然后再删除，时间复杂度为O(n)。


## 总结： ##

从源码可以看出
1、 get(int index)、set(int index, E element)，ArrayList明显快于LinkedList，因为LinkedList需要移动指针

2、add(E) ArrayList和LinkedList都是直接插入尾部

3、add(int index, E element) ArrayList需要移动后面的元素，LinkedList需要遍历指针(需要具体分析)

4、remove(int index)/remove(Object o) ArrayList需要移动后面的元素，LinkedList需要遍历指针(需要具体分析)