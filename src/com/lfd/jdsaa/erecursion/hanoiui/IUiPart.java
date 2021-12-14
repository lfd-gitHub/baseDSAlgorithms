package com.lfd.jdsaa.erecursion.hanoiui;
import java.awt.*;

public interface IUiPart {
    public void draw(Graphics2D g);
    public Rect getBounds();
    public IUiPart setBounds(int x,int y,int w,int h);
    public void offset(int x,int y);
}
