package com.lfd.jdsaa.erecursion.hanoiui;

public class Rect {
    
    int x,y,w,h;
    private Offset offset = new Offset(0,0);

    public Rect(){
        this(0,0,0,0);
    }

    public Rect(int x, int y, int w, int h) {
        this.update(x, y, w, h);
    }

    public void update(int x, int y, int w, int h){
        this.offset(x, y);
        this.w = w;
        this.h = h;
    }

    public void offset(int x, int y){
        this.offset.update(x, y);
        this.x = x;
        this.y = y;
    }
    
    public Offset getOffset(){
        return offset;
    }
}
