package br.com.marsalsilveira.readr.application.view;

/**
 *
 */
public interface ReadrView {

    //******************************************************************************************************************
    //* Open / Close
    //******************************************************************************************************************

    // default behavior for these methods are `do nothing...`.
    // Default behavior is `nothing` because these can be unnecessary to some kind of view.
    default void open() {}
    default void close() {}

    //******************************************************************************************************************
    //* Output / Input
    //******************************************************************************************************************

    void output();
    void output(String text);
    void outputError(String text);

    String input(String prefix);
    String input();
}