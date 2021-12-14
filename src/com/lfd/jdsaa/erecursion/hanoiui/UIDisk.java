package com.lfd.jdsaa.erecursion.hanoiui;

import java.awt.*;
import java.util.ArrayList;
import java.util.List;

public class UIDisk implements IUiPart {

    ////////////////////////
    private int dWidth = 100;
    private int dHeight = 50;
    private int aDX = (800 - 30) / 2 - 200 - (100 - 50) / 2 + 25;
    private int aDY = (600 - 200) / 2 + 200 - 50;
    private int aDYStep = 15;
    private int aDw = 10;
    ////////////////////////

    private int index;
    private int pillar;
    private Rect bounds = new Rect();
    private Color color;

    public static List<Color> colors;

    static {
        colors = new ArrayList<>();
        colors.add(new Color(127, 255, 0));
        colors.add(new Color(178, 34, 34));
        colors.add(new Color(240, 128, 128));
        colors.add(new Color(255, 127, 80));
        colors.add(new Color(255, 222, 173));
        colors.add(new Color(255, 215, 0));
        colors.add(new Color(138, 43, 226));
        colors.add(new Color(210, 105, 30));

    }

    private int circleWidth = 0;
    private int circleBaseX = 0;
    private String name = "";

    public UIDisk(String name, int index) {
        this.index = index;
        this.name = name;
        this.color = colors.get(index % colors.size());
        this.circleWidth = dWidth - aDw * index;
        this.circleBaseX = aDX + aDw / 2 * index;
    }

    public UIDisk update(int curIndex, int pillar) {
        this.pillar = pillar;
        bounds.update(
                circleBaseX + pillar * 190,
                aDY - curIndex * aDYStep,
                circleWidth,
                dHeight);
        return this;
    }

    public int getPillar() {
        return pillar;
    }

    public int getIndex() {
        return index;
    }

    public Rect getBounds() {
        return bounds;
    }

    @Override
    public void offset(int x, int y) {
        this.bounds.offset(x, y);
    }

    private int strokeWidth = 20;
    private Stroke lineStroke = new BasicStroke(strokeWidth);

    public void draw(Graphics2D g) {
        g.setColor(color);
        g.setStroke(lineStroke);
        g.drawOval(bounds.x, bounds.y, bounds.w, bounds.h);
        g.drawString(name, bounds.x - 20, bounds.y);
    }

    @Override
    public IUiPart setBounds(int x, int y, int w, int h) {
        this.bounds.update(x, y, w, h);
        return this;
    }

}
