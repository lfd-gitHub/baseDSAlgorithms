package com.lfd.jdsaa.erecursion.hanoiui;

import java.awt.*;

public class UIBed implements IUiPart {

    private Rect bounds = new Rect();
    private int shadowX = 20;
    private int shadowY = 100;
    private Color color = new Color(135, 206, 235);
    private Polygon polygon = new Polygon();

    @Override
    public void draw(Graphics2D g) {
        g.setColor(color);
        polygon.reset();
        polygon.addPoint(bounds.x, bounds.y);
        polygon.addPoint(bounds.x + bounds.w, bounds.y);
        polygon.addPoint(bounds.x + bounds.w + shadowX, bounds.y - shadowY);
        polygon.addPoint(bounds.x + shadowX , bounds.y - shadowY);
        g.fillPolygon(polygon);

        g.setColor(Color.GRAY);
        g.drawLine(bounds.x + bounds.w / 3, bounds.y, bounds.x + bounds.w / 3 + shadowX, bounds.y - shadowY);
        g.drawLine(bounds.x + bounds.w * 2/3, bounds.y, bounds.x + bounds.w * 2/3 + shadowX, bounds.y - shadowY);
        g.setColor(Color.BLACK);
        g.drawString("A", bounds.x + 20, bounds.y + 20);
        g.drawString("B", bounds.x + bounds.w / 3 + 20, bounds.y + 20);
        g.drawString("C", bounds.x + bounds.w * 2/3 + 20, bounds.y + 20);

    }

    @Override
    public Rect getBounds() {
        return bounds;
    }

    @Override
    public IUiPart setBounds(int x, int y, int w, int h) {
        this.bounds.update(x, y, w, h);
        return this;
    }

    @Override
    public void offset(int x, int y) {
        bounds.getOffset().update(x, y);
    }

}
