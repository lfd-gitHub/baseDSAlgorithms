package com.lfd.jdsaa.cqueue;


public class Queue {
    
    int[] es;

    public Queue(){
        es = new int[0];
    }

    public void add(int e){
        int[] newEs = new int[es.length + 1];
        System.arraycopy(es, 0, newEs, 0, es.length);
        newEs[es.length] = e;
        es = newEs;
    }

    public int poll(){
        if(es.length == 0)throw new RuntimeException("pop a empty queue");
        int e = es[0];
        int[] newEs = new int[es.length -1];
        System.arraycopy(es, 1, newEs, 0, newEs.length);
        es = newEs;
        return e;
    }

    public boolean isEmpty(){
        return es.length == 0;
    }

    public static void main(String[] args) {
        Queue queue = new Queue();
        queue.add(1);
        queue.add(2);
        System.out.println("poll -> " + queue.poll());
        System.out.println("poll -> " + queue.poll());
    }
}
