package com.lfd.jdsaa.fsort;

import java.util.Arrays;

public class BubbleSort implements IAlgorithm<int[],int[]>{

    @Override
    public void execute(int[] datas) {
         try {
            bubble(datas);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    private IAlgorithmStep<int[]> stepper;

    @Override
    public void setStepper(IAlgorithmStep<int[]> stepper) {
        this.stepper = stepper;
    }

    public int[] bubble(int[] arr) throws InterruptedException {
        int[] copy = Arrays.copyOf(arr, arr.length);
        //System.out.println("copy:" + Arrays.toString(copy));

        for (int i = 0; i < copy.length - 1; i++) {
            for (int j = 0; j < copy.length - i - 1; j++) {
                int temp1 = copy[j];
                int temp2 = copy[j + 1];

                boolean hasChange = temp1 > temp2;
                if (temp1 > temp2) {
                    copy[j] = temp2;
                    copy[j + 1] = temp1;
                    System.out.println(String.format("[%s] pos[%d,%d] = [%d,%d] => [%d,%d]", "Sort", j, j + 1, temp1,
                             temp2, copy[j], copy[j + 1]));
                    if(Thread.currentThread().isInterrupted()){
                        return copy;
                    }         
                }
                if (stepper != null) {
                    stepper.onStep(new int[]{j,j+1,hasChange ? 1 : 0});
                }
            }
        }
        return copy;
    }
    
}
