package com.lfd.jdsaa.fsort.sortui;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Toolkit;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.swing.JFrame;

import com.lfd.jdsaa.fsort.IAlgorithm;
import com.lfd.jdsaa.fsort.IAlgorithm.IAlgorithmStep;
import com.lfd.jdsaa.fsort.sortui.OperUI.OnClickListener;

public class SortWindow extends JFrame implements OnClickListener {

    private int width = 800;
    private int height = 600;

    private int screenWidth;
    private int screenHeight;

    private OperUI operUI;
    private AnimUI animUI;

    public SortWindow(String[] algNames) {
        setTitle("排序");
        setDefaultLookAndFeelDecorated(true);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        Dimension screensize = Toolkit.getDefaultToolkit().getScreenSize();
        this.screenWidth = (int) screensize.getWidth();
        this.screenHeight = (int) screensize.getHeight();
        this.setVisible(true);
        this.setPreferredSize(new Dimension(width, height));
        this.setBounds((screenWidth - width) / 2, (screenHeight - height) / 2, width, height);
        this.setLayout(new BorderLayout());

        this.animUI = new AnimUI();
        add(this.animUI, BorderLayout.CENTER);

        this.operUI = new OperUI();
        this.operUI.setOnItemClick(this);
        add(this.operUI, BorderLayout.SOUTH);
    }

    private int[] sortDats;

    public void setSortDatas(int[] arr) {
        this.sortDats = arr;
    }

    private IAlgorithmStep<int[]> stepper = new IAlgorithmStep<int[]>() {

        @Override
        public void onStep(int[] step) throws InterruptedException {
            SortWindow.this.animUI.updateIdxs(step);
        }
    };

    private Map<String, IAlgorithm<int[], int[]>> algors = new HashMap<>();

    public void addAlgorithm(IAlgorithm<int[], int[]> algorithm) {
        String name = algorithm.getClass().getSimpleName();
        this.operUI.addButtons(new String[] { name });
        algorithm.setStepper(stepper);
        algors.put(name, algorithm);
    }

    ExecutorService sExecutorService;

    @Override
    public void onClick(String name) {
        switch (name) {
            case "pause":
                this.animUI.pause();
                break;
            case "resume":
                this.animUI.resume();
                break;
            default:
                if (sortDats != null && algors.containsKey(name)) {
                    SortWindow.this.animUI.setDatas(sortDats);
                    if (sExecutorService != null && !sExecutorService.isShutdown()) {
                        sExecutorService.shutdownNow();
                        sExecutorService = null;
                    } else {
                        sExecutorService = Executors.newSingleThreadExecutor();
                        sExecutorService.submit(new Runnable() {
                            @Override
                            public void run() {
                                algors.get(name).execute(sortDats);
                            }
                        });
                    }

                }
                break;
        }
    }
}
