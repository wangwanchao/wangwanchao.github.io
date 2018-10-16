## java语言实现
```

	public static void main(String[] args){
        // main live template
        int[] arr = {3, 7, 5, 1, 8, 6};

        quickSort(arr, 0, arr.length-1);

        Arrays.stream(arr).forEach( value -> {
            System.out.println(value);
        });
    }

    public static void quickSort(int[] a, int low, int high) {
        int i = low;
        int j = high;
        int base = a[low];

        while (i < j){

            while(a[j] > base && i < j){
                j--;
            }
            if ( i < j ) {
                int temp = a[j];
                a[j] = a[i];
                a[i] = temp;
                i++;

                while(a[i] < base && i < j) {
                    i++;
                }
                if( i < j ) {
                    int temp2 = a[i];
                    a[i] = a[j];
                    a[j] = temp2;
                    j--;
                }
            }
        }

        a[i] = base;

        if (low < i-1) {
            quickSort(a, low, i-1);
        }
        if (j+1 < high) {
            quickSort(a, j+1, high);
        }
    }
```
    
## go语言实现

```package main

import (
	"fmt"
)

func main() {
	// fmt.Println("Hello Mac go")

	arr := []int{3, 7, 5, 1, 8, 6}

	quick_sort(arr, 0, len(arr)-1)

	for v := range arr {
		fmt.Println(arr[v])
	}
}

func quick_sort(a []int, low int, high int) {
	i := low
	j := high
	base := a[low]

	for ; i < j; {

		for ; a[j] > base && i < j; {
			j--
		}

		if i < j {
			temp := a[j]
			a[j] = a[i]
			a[i] = temp
			i++

			for ; a[i] < base && i < j; {
				i++
			}
			if i < j {
				temp2 := a[i]
				a[i] = a[j]
				a[j] = temp2
				j--
			}
		}
	}

	a[i] = base

	if low < i-1 {
		quick_sort(a, low, i-1)
	}
	if j+1 < high {
		quick_sort(a, j+1, high)
	}
}
```












