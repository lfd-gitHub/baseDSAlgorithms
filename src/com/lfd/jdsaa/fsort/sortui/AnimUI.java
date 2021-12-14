package com.lfd.jdsaa.fsort.sortui;

import javax.swing.*;
import java.awt.*;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.SynchronousQueue;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class AnimUI extends JPanel {

    private volatile boolean isPause = false;
    private Lock rLock = new ReentrantLock();
    private final Condition cPause = rLock.newCondition();

    private int padVer = 50;
    private int padHor = 25;
    private int dataGap = 5;

    private int maxOfDatas = 0;
    private int minOfDatas = 0;
    private int minDataHPx = 10;
    private int perDataWPx = -1;
    private int perDataHPx = -1;
    private int count = 0;
    private BlockingQueue<int[]> queue;

    private int[] datas;
    private int[] updatedIdxs;

    private SwingWorker<Void, int[]> sWorker = null;

    public AnimUI() {
        queue = new SynchronousQueue<>();
        sWorker = new SwingWorker<Void, int[]>() {
            @Override
            protected Void doInBackground() throws Exception {
                while (true) {
                    System.out.println(String.format("[%s][worker] state = %b", "AnimUI",
                            isPause));
                    int[] arr = queue.take();
                    publish(arr);
                    Thread.sleep(1000);
                }
            }

            @Override
            protected void process(List<int[]> chunks) {
                super.process(chunks);
                int[] datas = chunks.get(0);
                updatedIdxs = datas;
                repaint();
            }
        };
        sWorker.execute();
    }

    private void resetStates() {
        this.perDataWPx = 0;
        this.perDataHPx = 0;
    }

    ExecutorService exe = Executors.newSingleThreadExecutor();

    public void updateIdxs(int[] idxs) throws InterruptedException {
        try {
            System.out.println(String.format("[%s][%s][idxs] = %s", "AnimUI",
                    Thread.currentThread().getName(), Arrays.toString(idxs)));

            if (isPause) {
                try {
                    rLock.lock();
                    cPause.await();
                } finally {
                    rLock.unlock();
                }
            }
            queue.put(Arrays.copyOf(idxs, idxs.length));
        } catch (InterruptedException e) {
            e.printStackTrace();
            throw e;
        }
    }

    public void setDatas(int[] datas) {
        int[] copyDatas = Arrays.copyOf(datas, datas.length);

        if (this.datas == null || copyDatas.length != this.datas.length) {
            this.resetStates();
            this.count = copyDatas.length;
            for (int d : copyDatas) {
                if (maxOfDatas < d)
                    this.maxOfDatas = d;
                if (minOfDatas > d)
                    this.minOfDatas = d;
            }
        }
        this.datas = copyDatas;
        repaint();
        System.out.println(String.format("[%s][repaint] max = %d , min = %d | arr = %s",
                getClass().getSimpleName(),
                maxOfDatas, //
                minOfDatas, //
                Arrays.toString(datas)));
    }

    public void paint(Graphics g) {
        super.paint(g);
        Graphics2D g2d = (Graphics2D) g;
        int width = getWidth() - padHor * 2;
        int height = getHeight() - padVer * 2;

        g2d.setColor(Color.PINK);
        g2d.clearRect(0, 0, getWidth(), getHeight());

        if (count <= 0)
            return;
        if (perDataWPx <= 0) {
            perDataWPx = (width - (count - 1) * dataGap) / count;
        }
        if (maxOfDatas == 0)
            return;
        int abs = Math.abs(maxOfDatas - minOfDatas);
        if (perDataHPx <= 0) {
            perDataHPx = (height - dataGap * 2) / abs;
        }
        if (this.datas != null) {

            int from = -1;
            int to = -1;
            boolean hasChanged = false;

            if(updatedIdxs != null){
                from = updatedIdxs[0];
                to = updatedIdxs[1];
                hasChanged = updatedIdxs[2] == 1;

                if(hasChanged){
                    int temp = datas[from];
                    datas[from] = datas[to];
                    datas[to] = temp;
                }
            }

            for (int i = 0; i < datas.length; i++) {
                int data = datas[i];

                int boxX = i * (perDataWPx + dataGap) + padHor;
                int boxH = (data - minOfDatas) * perDataHPx + minDataHPx;

                if (from == i || to == i) {
                    g2d.setColor(Color.CYAN);
                    g2d.fillRect(boxX, height + padVer, perDataWPx, 4);
                }

                g2d.setColor(Color.PINK);
                g2d.fillRect(boxX, height - boxH + padVer, perDataWPx, boxH);
                g2d.setColor(Color.BLUE);
                g2d.drawString(String.valueOf(data), boxX, height - boxH + padVer);
            }
        }

    }

    public void pause() {
        this.isPause = true;
    }

    public void resume() {
        boolean isPause = this.isPause;
        this.isPause = false;
        if(isPause){
            try {
                rLock.lock();
                cPause.signal();
            } finally {
                rLock.unlock();
            } 
        }
    }
}
