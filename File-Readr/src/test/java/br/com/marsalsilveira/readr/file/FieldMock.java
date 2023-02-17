package br.com.marsalsilveira.readr.file;

import br.com.marsalsilveira.readr.file.model.ReadrField;

/**
 * Mock field for test purpose.
 */
public class FieldMock implements ReadrField {

    //******************************************************************************************************************
    //* Properties
    //******************************************************************************************************************

    private final String _name;
    public String name() { return _name; }

    private final String _value;
    public String value() { return _value; }

    //******************************************************************************************************************
    //* Constructor
    //******************************************************************************************************************

    public FieldMock(String name, String value) {

        _name = name;
        _value = value;
    }
}