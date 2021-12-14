package com.lfd.jdsaa.erecursion.hanoiui;

public class Offset {
    private int x,y;

    public Offset() {
        this.update(0,0);
    }

    public Offset(int x, int y) {
        this.update(x, y);
    }

    public void update(int x,int y){
        this.x = x;
        this.y = y;
    }

    public int getX() {
        return x;
    }
    public int getY() {
        return y;
    }
}
