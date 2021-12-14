package com.lfd.jdsaa.dlink;

public class LoopLink<T> {

    private LNode<T> head;
    private int size = 0;

    public LoopLink<T> addFirst(T data) {
        LNode<T> node = new LNode<>(data);
        LNode<T> _last = getLast();

        _last.next = node;
        node.next = this.head;
        this.head = node;

        size++;
        return this;
    }

    public LoopLink<T> appendLast(T data) {
        LNode<T> node = new LNode<>(data);
        if (isEmpty()) {
            this.head = node;
            this.head.next = this.head;
        } else {
            LNode<T> _last = getLast();
            _last.next = node;
            node.next = this.head;
        }
        this.size++;
        return this;
    }

    public T removeAt(int pos){
        if (isEmpty()) return null;
        LNode<T> last = getLast();
        LNode<T> pre = last;
        LNode<T> cur = this.head;
        int index = 0;
        do{
            if(index == pos){
                if(cur == head){
                    if(size == 1){
                        this.head = null;
                    }else{
                        this.head = this.head.next;
                        last.next = this.head;
                    }
                }else{
                    pre.next = cur.next;
                }
                this.size--;
                return cur.value();
            }
            pre = cur;
            cur = cur.next;
        }while(index++ != pos);
        return null;
    }

    public void insertAt(int pos, T data) {
        if (pos < 0)
            pos = 0;
        if (pos > size)
            pos = size;
        int idx = 0;
        LNode<T> node = new LNode<>(data);
        if (isEmpty()) {
            appendLast(data);
            return;
        }
        LNode<T> pre = getLast();
        LNode<T> cur = this.head;
        while (idx <= size) {
            if (idx == pos) {
                pre.next = node;
                node.next = cur;
                this.size++;
                return;
            }
            idx++;
            pre = cur;
            cur = cur.next;
        }

    }

    public T remove(T data) {
        if (isEmpty()) return null;
        LNode<T> last = getLast();
        LNode<T> pre = last;
        LNode<T> cur = this.head;
        do {
            if (cur.value() == data || cur.value().equals(data)) {
                if(cur == head){
                    if(size == 1){
                        this.head = null;
                    }else{
                        this.head = this.head.next;
                        last.next = this.head;
                    }
                }else{
                    pre.next = cur.next;
                }
                this.size--;
                return data;
            }
            pre = cur;
            cur = cur.next;
        } while (cur != head);
        return null;
    }

    public boolean has(T data) {
        if (isEmpty())
            return false;
        LNode<T> cur = this.head;
        do {
            if (cur.value() == data || cur.value().equals(data)) {
                return true;
            }
            cur = cur.next;
        } while (cur != head);
        return false;
    }

    public int size() {
        return size;
    }

    public boolean isEmpty() {
        return head == null;
    }

    public LNode<T> getFirst() {
        return head;
    }

    public LNode<T> getLast() {
        if (isEmpty())
            throw new RuntimeException("link is empty");
        LNode<T> cur = this.head;
        while (cur.next != this.head) {
            cur = cur.next;
        }
        return cur;
    }

    public void show() {
        if (this.head == null)
            return;
        LNode<T> cur = this.head;
        StringBuilder sBuilder = new StringBuilder();
        sBuilder.append("[");
        sBuilder.append(cur.value());
        sBuilder.append("]");
        while (cur.next != this.head) {
            cur = cur.next;
            sBuilder.append("->[");
            sBuilder.append(cur.value());
            sBuilder.append("]");
        }
        System.out.println(sBuilder);
    }

    public static class LNode<T> {
        private T data;
        private LNode<T> next;

        public LNode(T data) {
            this.data = data;
        }

        public void setNext(LNode<T> next) {
            this.next = next;
        }

        public LNode<T> getNext() {
            return next;
        }

        public T value() {
            return data;
        }
    }

    public static void main(String[] args) {

        LoopLink<Integer> ll = new LoopLink<>();
        ll.insertAt(0, 1);
        ll.insertAt(100, 2);
        ll.addFirst(0);
        ll.appendLast(3);
        ll.show();
        System.out.println("first => " + ll.getFirst().value());
        System.out.println("last => " + ll.getLast().value());
        System.out.println("isEmpty => " + ll.isEmpty());
        System.out.println("size => " + ll.size());
        System.out.println("has 3 => " + ll.has(3));
        System.out.println("has 2 => " + ll.has(2));
        System.out.println("has 0 => " + ll.has(0));
        ll.remove(2);
        ll.show();
        System.out.println("================");
        ll.remove(0);
        ll.show();
        System.out.println("================");
        ll.remove(3);
        ll.show();
        System.out.println("================");
        ll.remove(1);
        ll.show();
        System.out.println("isempty - " + ll.isEmpty());
        /////////////// 约瑟夫环 ////////////////////
        final int n = 50;//5个人
        for (int i = 0; i < n; i++) {
            ll.appendLast(i+1);
        }
        ll.show();
        final int count = 3;//数到第3个人
        int idx = 0;
        while(!ll.isEmpty()){
            idx += count;
            System.out.println("remove " + ll.removeAt(idx));
            ll.show();
        }

        System.out.println("current size " +ll.size());
        ll.show();
    }

}
