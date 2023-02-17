package br.com.marsalsilveira.readr.application.view;

import br.com.marsalsilveira.readr.utils.StringUtils;

import java.io.PrintStream;
import java.util.Scanner;

/**
 * Abstraction to std view (cli).
 */
public final class ConsoleView implements ReadrView {

    //******************************************************************************************************************
    //* Properties
    //******************************************************************************************************************

    private final PrintStream _output;
    private final PrintStream _outputErr;
    private final Scanner _input;

    //******************************************************************************************************************
    //* Constructor
    //******************************************************************************************************************

    public ConsoleView() {

        _output = System.out;
        _outputErr = System.err;
        _input = new Scanner(System.in);
    }

    //******************************************************************************************************************
    //* Open / Close
    //******************************************************************************************************************

    public void close() {

        _output.close();
        _outputErr.close();
        _input.close();
    }

    //******************************************************************************************************************
    //* Output / Input
    //******************************************************************************************************************

    public void output() {

        this.output(null);
    }

    public void output(String str) {

        // to avoid output `null` into view
        _output.println(StringUtils.isEmpty(str) ? "" : str);
    }

    public void outputError(String str) {

        // to avoid output `null` into view
        _outputErr.println(StringUtils.isEmpty(str) ? "" : str);
    }

    public String input(String prefix) {

        _output.print(StringUtils.isEmpty(prefix ) ? "> " : prefix);

        // wait until user type any value...
        String input = _input.nextLine();

        return input.trim().toLowerCase();
    }

    public String input() {

        return this.input(null);
    }
}