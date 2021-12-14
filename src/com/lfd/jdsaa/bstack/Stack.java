package com.lfd.jdsaa.bstack;

import java.util.Arrays;

public class Stack {
    
    private int[] es = new int[0];

    public void push(int e){
        int[] newArr = new int[es.length + 1];
        System.arraycopy(es, 0, newArr, 0, es.length);
        newArr[es.length] = e;
        this.es = newArr;
    }

    public int pop(){
        int indexEnd = es.length -1;
        if(indexEnd < 0){
           throw new RuntimeException("pop a empty stack");
        }
        int top = es[indexEnd];
        this.es = Arrays.copyOf(es,indexEnd);
        return top;
    }

    public int peek(){
        int indexEnd = es.length - 1;
        if(indexEnd < 0){
            throw new RuntimeException("peek a empty stack");
        }
        return this.es[indexEnd];
    }

    public boolean isEmpty(){
        return this.es.length == 0;
    }

    public static void main(String[] args) {
        Stack s = new Stack();
        s.push(1);
        s.push(2);
        System.out.println(s.pop() + ":" + s.peek()); 
        System.out.println(s.pop() + ":" + s.peek()); 
        System.out.println(s.pop() + ":" + s.peek()); 
    }
}
