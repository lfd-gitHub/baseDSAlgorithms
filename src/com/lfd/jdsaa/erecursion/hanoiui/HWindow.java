package com.lfd.jdsaa.erecursion.hanoiui;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.SwingWorker;

import com.lfd.jdsaa.erecursion.Hanoi;
import com.lfd.jdsaa.erecursion.Hanoi.MoveEventListener;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.List;

public class HWindow extends JFrame {

    public static void main(String[] args) {

        HWindow hWindow = new HWindow(5);
        hWindow.pack();

    }

    private int width = 800;
    private int height = 600;

    private int screenWidth;
    private int screenHeight;
    private Painter painter;
    private JButton btn = new JButton("开始");
    private int count = 3;

    public HWindow(int count) {
        this.count = count;
        setTitle("汉诺塔");
        setDefaultLookAndFeelDecorated(true);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        Dimension screensize = Toolkit.getDefaultToolkit().getScreenSize();
        this.screenWidth = (int) screensize.getWidth();
        this.screenHeight = (int) screensize.getHeight();
        this.setPreferredSize(new Dimension(width, height));
        this.setVisible(true);
        this.setBounds((screenWidth - width) / 2, (screenHeight - height) / 2, width, height);

        setLayout(null);
        btn.setBounds(380, 520, 100, 50);
        add(btn);
        painter = new Painter();
        painter.setBounds(0, 0, width, height-100);
        add(painter);

        btn.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                if (!isStart) {
                    isStart = true;
                    btn.setText("停止");
                    startExchange(count);
                } else {
                    isStart = false;
                    btn.setText("开始");
                    canceExchange();
                    
                }
            }

        });

        resetExchange();
    }

    private boolean isStart = false;

    public void resetExchange() {

        painter.disks.clear();
        painter.disks.add(new ArrayList<>());
        painter.disks.add(new ArrayList<>());
        painter.disks.add(new ArrayList<>());
        for (int i = 0; i < count; i++) {
            painter.disks.get(0).add(new UIDisk(String.valueOf(count - i), i).update(i, 0));
        }
        painter.repaint();
    }

    private SwingWorker<Boolean, ProgressInfo> sWorker;

    public void canceExchange(){
        if (sWorker != null && !sWorker.isCancelled()) {
            System.out.println("cancel!");
            sWorker.cancel(true);
            sWorker = null;
        }        
    }

    public void startExchange(int count) {
        if (sWorker != null && !sWorker.isCancelled()) {
            System.out.println("cancel old!");
            sWorker.cancel(true);
            sWorker = null;
        }

        if (isStart) {
            resetExchange();
        }

        if (!isStart)
            return;

        sWorker = new SwingWorker<Boolean, ProgressInfo>() {
            protected Boolean doInBackground() throws Exception{
                Hanoi.move(count, 'A', 'B', 'C', new MoveEventListener() {
                    @Override
                    public void onMove(int index, char from, char to) throws InterruptedException {
                        try {
                            System.out.println("moving...");
                            publish(new ProgressInfo(index, from, to));
                            Thread.sleep(1000);
                        } catch (InterruptedException e) {
                            resetExchange();
                            throw e;
                        }
                    }
                });
                return true;
            };

            @Override
            protected void process(List<ProgressInfo> chunks) {
                ProgressInfo pInfo = chunks.get(0);
                List<UIDisk> disksFrom = painter.disks.get(pInfo.from - 'A');
                List<UIDisk> disksTo = painter.disks.get(pInfo.to - 'A');
                UIDisk disk = disksFrom.remove(disksFrom.size() - 1);
                disk.update(disksTo.size(), pInfo.to - 'A');
                disksTo.add(disk);
                System.out.println(String.format("%b [%d, %d, %d] | 第%d号圆盘从%s 移动到%s",
                        isStart,
                        painter.disks.get(0).size(),
                        painter.disks.get(1).size(),
                        painter.disks.get(2).size(), pInfo.index, pInfo.from, pInfo.to));
                painter.repaint();
            }

            protected void done() {
                btn.setText("开始");
                painter.repaint();
            };

        };
        sWorker.execute();
    }

    public class ProgressInfo {
        int index;
        char from;
        char to;

        public ProgressInfo(int index, char from, char to) {
            this.index = index;
            this.from = from;
            this.to = to;
        }

        @Override
        public String toString() {
            return "ProgressInfo [from=" + from + ", index=" + index + ", to=" + to + "]";
        }

    }

    public class Painter extends JPanel {

        private List<List<UIDisk>> disks = new ArrayList<>();
        private List<IUiPart> uiParts = new ArrayList<>();

        public Painter() {

            int scenter = (width - 30) / 2;
            int ptop = (height - 200) / 2;
            int pWidth = 50;
            int pHeight = 200;

            uiParts.add(new UIBed().setBounds(scenter - 200 - 50, ptop + pHeight + 50, 400 + pWidth + 100, 100));
            // uiParts.add(new UIPillar().setBounds(scenter - 200, ptop, pWidth, pHeight));
            // uiParts.add(new UIPillar().setBounds(scenter, ptop, pWidth, pHeight));
            // uiParts.add(new UIPillar().setBounds(scenter + 200, ptop, pWidth, pHeight));

        }

        @Override
        public void paint(Graphics g) {
            super.paint(g);
            Graphics2D g2d = (Graphics2D) g;
            g2d.clearRect(0, 0, width, height);
            g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                    RenderingHints.VALUE_ANTIALIAS_ON);
            for (IUiPart uiPart : uiParts) {
                uiPart.draw(g2d);
            }
            for (List<UIDisk> list : disks) {
                for (IUiPart uiDisk : list) {
                    uiDisk.draw(g2d);
                }
            }
        }
    }
}
