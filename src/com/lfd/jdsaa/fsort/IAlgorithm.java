package com.lfd.jdsaa.fsort;

public interface IAlgorithm<T,S> {

    public void setStepper(IAlgorithmStep<S> stepper);

    void execute(T data);

    public static interface IAlgorithmStep<S>{
        void onStep(S step) throws InterruptedException;
    }
}
