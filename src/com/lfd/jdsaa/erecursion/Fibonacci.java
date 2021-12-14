package com.lfd.jdsaa.erecursion;

public class Fibonacci {

    /**
     * 获取第n项斐波那契数值
     * @param n 从1开始
     * @return
     */
    public static int fib(int n){
        if(n <= 2){
            return n - 1;
        }
        return fib(n-1) + fib(n - 2);
    }

    public static void main(String[] args) {
        for (int i = 1; i < 20; i++) {
            System.out.print(fib(i));
            System.out.print(",");
        }
        System.out.println();
    }
    
}
