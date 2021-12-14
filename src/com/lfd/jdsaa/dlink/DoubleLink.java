package com.lfd.jdsaa.dlink;

/**
 * 双向循环链表
 */
public class DoubleLink<T> {
 
    private int size = 0;
    private DNode<T> head;

    public int size() {
        return size;
    }

    public void insertAt(int pos,T data){
        DNode<T> node = new DNode<>(data);
        if(head == null){
            this.head = node;
            size ++;
        }else{
            int index = 0;
            DNode<T> pre = this.head.pre;
            DNode<T> cur = this.head;
            do{
                if(index == pos){
                    pre.next = node;
                    node.pre = pre;
                    node.next = cur;
                    cur.pre = node;
                    size ++;
                    break;
                }
                pre = cur;
                cur = cur.next;
            }while(index++ != pos);
        }
        
    }

    public T removeAt(int pos){
        if(head != null){
            int index = 0;
            DNode<T> pre = this.head.pre;
            DNode<T> cur = this.head;
            do{
                if(index == pos){
                    if(size == 1){
                        this.head = null;
                        this.size = 0;
                        return cur.value;
                    }else{
                        T value = cur.value();
                        if(index == 0) this.head = cur.next;
                        pre.next = cur.next;
                        cur.next.pre = pre;
                        this.size --;
                        return value;
                    }
                }
                pre = cur;
                cur = cur.next;
            }while(index++ != pos && index < size);
        }
        throw new RuntimeException("out of range!");
    }

    public void show() {
        if (this.head == null)
            return;
        DNode<T> pre = this.head.pre;    
        DNode<T> cur = this.head;
        System.out.print("link : ");
        System.out.print("[");
        System.out.print(cur.value());
        System.out.print("]");
        while (cur.next != this.head) {
            pre = cur;
            cur = cur.next;
            if(cur.pre == pre && pre.next == cur){
                System.out.print("<");
            }
            System.out.print("->[");
            System.out.print(cur.value());
            System.out.print("]");
        }
        System.out.println();
    }

    private static class DNode<T>{

        T value;
        DNode<T> pre = this;
        DNode<T> next = this;

        public DNode(T value) {
            this.value = value;
        }
    
        public T value() {
            return value;
        }
    }

    public static void main(String[] args) {
        DoubleLink<Integer> dl = new DoubleLink<>();
        dl.insertAt(0, 1);
        dl.insertAt(1, 2);
        dl.insertAt(2, 3);
        dl.show();
        System.out.println("size = " + dl.size());
        System.out.println("remove at 0 => " + dl.removeAt(0));;
        dl.show();
        System.out.println("remove at 1 => " + dl.removeAt(1));;
        dl.show();
        System.out.println("remove at 0 => " + dl.removeAt(0));;
        dl.show();
    }
}
