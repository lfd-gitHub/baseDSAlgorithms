package com.lfd.jdsaa.dlink;

import java.util.Iterator;

public class SingleLink<T> implements Iterable<T>,Iterator<T>{

    private SNode<T> root;
    private SNode<T> itNode;
    private int size;

    public SingleLink<T> append(T data) {
        SNode<T> node = new SNode<>(data);
        if (root == null) {
            root = node;
        } else {
            SNode<T> cNode = root;
            while (cNode.next != null) {
                cNode = cNode.next;
            }
            cNode.next = node;
        }
        this.size ++;
        return this;
    }

    public int size() {
        return size;
    }

    public boolean hasNext(){
        if(size == 0) return false;
        return this.itNode != null;
    }

    @Override
    public T next() {
        if(this.itNode == null){
            throw new RuntimeException("out of range");
        }
        T value = this.itNode.value();
        this.itNode = this.itNode.next;
        return value;
    }


    @Override
    public Iterator<T> iterator() {
        this.itNode = this.root;
        return this;
    }

    public T getAt(int index) {
        if(index > size){
            throw new RuntimeException("index out of range");
        }
        SNode<T> current = this.root;
        int _index = 0;
        while(current != null){
            if(_index == index) return current.value();
            current = current.next;
            _index++;
        }
        return null;
    }

    public void insertAt(int index,T data){
        if(index > size){
            throw new RuntimeException("index out of range");
        }
        if(index == size){
            append(data);
            return;
        }
        SNode<T> pre = null;
        SNode<T> current = this.root;
        int _index = 0;
        SNode<T> sNode = new SNode<T>(data);
        while(current != null){
            if(_index == index){
                sNode.next = current;
                if(pre == null){
                    this.root = sNode;
                }else{
                    pre.next = sNode;
                }
                this.size ++;
                return;
            }
            pre = current;
            current = current.next;
            _index ++;
        }
    }

    public T delete(T data) {
        SNode<T> pre = null;
        SNode<T> cur = this.root;
        while(cur != null){
            T value = cur.value();
            if(value.equals(data)){
                if(pre == null){
                    this.root = cur.next;
                }else{
                    pre.next = cur.next;
                }
                this.size --;
                return cur.value();
            }
        }
        
        return null;
    }

    public void show(){
        if(root == null)return;
        SNode<T> cNext = this.root.next;
        StringBuilder sBuilder = new StringBuilder();
        sBuilder.append("[");
        sBuilder.append(this.root.value());
        sBuilder.append("]");
        while(cNext != null){
            if(cNext != null) sBuilder.append("->");
            sBuilder.append("[");
            sBuilder.append(cNext.data);
            sBuilder.append("]");
            cNext = cNext.next;
        }
        System.out.println(sBuilder);
    }

    private static class SNode<T> {

        private T data;
        private SNode<T> next;

        private SNode(T data) {
            this.data = data;
        }

        public T value() {
            return data;
        }
    }

    public static void main(String[] args) {
        SingleLink<String> link = new SingleLink<>();
        System.out.println("---------append a b c------------");
        link.append("a").append("b").append("c");
        link.show();
        System.out.println("---------delete a b c d------------");
        link.delete("a");
        link.delete("b");
        link.delete("c");
        link.delete("d");
        System.out.println("size = "+link.size());
        link.show();
        System.out.println("---------insert at 0 = 10 & 0 =20 ------------");
        link.insertAt(0, "10");
        link.insertAt(0, "20");
        link.show();
        System.out.println("size = "+link.size());
        System.out.println("-----------for----------");
        for (int i = 0; i < link.size(); i++) {
            System.out.println(i + " = "+link.getAt(i));
        }
        System.out.println("-----------iterator----------");
        Iterator<String> it =  link.iterator();
        while(it.hasNext()){
            System.out.println("it next => " + it.next());
        }
        System.out.println("-----------again----------");
        it =  link.iterator();
        while(it.hasNext()){
            System.out.println("it next => " + it.next());
        }
        //it.next();
    }
}
