package com.lfd.jdsaa.fsort.sortui;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.util.List;
import java.util.ArrayList;

public class OperUI extends JPanel implements ActionListener {

    private List<String> customButtons = new ArrayList<>();
    private OnClickListener onItemClick = null;

    public static interface OnClickListener {
        void onClick(String name);
    }

    public void setOnItemClick(OnClickListener onItemClick) {
        this.onItemClick = onItemClick;
    }

    public OperUI() {
        this.customButtons.add("pause");
        this.customButtons.add("resume");
        setLayout(new FlowLayout());
    }

    public void addButtons(String[] names){
        removeAll();
        this.customButtons.addAll(List.of(names));
        for (String bName : this.customButtons) {
            JButton btn = new JButton(bName);
            btn.setName(bName);
            btn.addActionListener(this);
            add(btn);
        }
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if (this.onItemClick == null)
            return;
        Object o = e.getSource();
        if (o instanceof JButton) {
            JButton ob = (JButton) o;
            String aName = ob.getName();
            this.onItemClick.onClick(aName);
        }
    }

}