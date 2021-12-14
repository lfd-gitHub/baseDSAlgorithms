package com.lfd.jdsaa.fsort;


import com.lfd.jdsaa.fsort.sortui.SortWindow;

public class Sort {

    public static void main(String[] args) {

        SortWindow sw = new SortWindow(new String[] { "bubble" });
        int[] sortData = new int[] { 7, 6, 10, 33, 8, 5, -2, 16, 27, 99, 5 };
        sw.setSortDatas(sortData);
        //冒泡排序
        sw.addAlgorithm(new BubbleSort());
    }

    public static interface ChangeListener {
        public void onChange(int[] arr);
    }
}
