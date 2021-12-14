package com.lfd.jdsaa.erecursion;

public class Hanoi {
    
    public static void move(int count,char from,char in,char to,MoveEventListener lis) throws InterruptedException{
        if(count <= 1){
            lis.onMove(count,from,to);
            return;
        }
        //除了最后一个圆盘，其他都移动到第二个柱子
        move(count-1,from, to, in,lis);
        //最后一个圆盘，移动到最后一个柱子
        lis.onMove(count,from,to);
        //再把剩下的盘子移动到最后一个柱子上
        move(count-1,in, from, to,lis);
    }

    public static void main(String[] args) throws InterruptedException {
        Hanoi.move(3, 'A', 'B', 'C',new MoveEventListener() {
            @Override
            public void onMove(int index, char from,char to) throws InterruptedException {
                System.out.println(String.format("第%d号圆盘从%s 移动到%s",index,from,to));
                throw new InterruptedException();
            }
        });
    }

    public static interface MoveEventListener{
        void onMove(int index,char from,char to) throws InterruptedException;
    } 
}
