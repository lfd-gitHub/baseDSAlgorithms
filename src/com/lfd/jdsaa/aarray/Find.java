package com.lfd.jdsaa.aarray;

/**
 * Find 查找算法
 */
public class Find {

    public static void main(String[] args) {
        //① 线性查找
        //② 二分查找有序数组
        int[] arr = new int[]{1,2,3,4,5,6,7};
        System.out.println("find:" +100 + " > " + binarySearch(arr, 3));
    }

    /**
     * 二分查找
     * @param arr 有序数组
     * @param target 查找目标
     * @return
     */
    public static int binarySearch(int[] arr,int target){
        
        int indexBegin = 0;
        int indexEnd = arr.length - 1;
        int indexCenter = (indexEnd + indexBegin) / 2;
        int index = 0;

        while(true){
            System.out.println("find-----" + indexBegin +":"+ indexCenter+"("+arr[indexCenter]+"):"+indexEnd);
            int centerData = arr[indexCenter];
            if(centerData == target){
                index = indexCenter;
                break;
            }
            if(centerData > target){
                indexEnd = indexCenter - 1;
            }else{
                indexBegin = indexCenter + 1;
            }
            if(indexBegin > indexEnd){
                index = -1;
                break;
            }
            indexCenter = (indexEnd + indexBegin) / 2;
        }
        return index;
    }
}