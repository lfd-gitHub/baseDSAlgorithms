package com.lfd.jdsaa.erecursion.hanoiui;
import java.awt.*;

public class UIPillar implements IUiPart{

    private final int shadowY = 15;
    private Rect bounds = new Rect();
    private Color color = new Color(112,128,144);
    private Color color2 = new Color(92,108,120);

    public UIPillar(){}

    public Rect getBounds(){
        return bounds;
    }

    @Override
    public void offset(int x, int y) {}

    public void draw(Graphics2D g){
        g.setColor(color);
        g.fillOval(bounds.x, bounds.y + bounds.h-shadowY, bounds.w, shadowY);
        g.setColor(color);
        g.fillRect(bounds.x, bounds.y + shadowY/2, bounds.w, bounds.h - shadowY);
        g.setColor(color2);
        g.fillOval(bounds.x, bounds.y, bounds.w, shadowY);

        // g.setColor(Color.GRAY);
        // g.drawRect(bounds.x - 1, bounds.y - 1, bounds.w + 2, bounds.h+2);
        // g.drawRect(bounds.x, bounds.y + bounds.h-shadowY, bounds.w, shadowY);
    }

    @Override
    public IUiPart setBounds(int x, int y, int w, int h) {
        this.bounds.update(x, y, w, h);
        return this;
    }
}
