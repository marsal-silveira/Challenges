package br.com.marsalsilveira.readr.file.csv;

import br.com.marsalsilveira.readr.file.model.ReadrField;
import br.com.marsalsilveira.readr.file.model.ReadrRecord;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class CsvRecord implements ReadrRecord {

    //******************************************************************************************************************
    //* Properties
    //******************************************************************************************************************

    private final List<ReadrField> _fields;
    public List<ReadrField> fields() { return _fields; }

    //******************************************************************************************************************
    //* Constructor
    //******************************************************************************************************************

    public CsvRecord() {

        _fields = new ArrayList<>();
    }

    //******************************************************************************************************************
    //* Utils
    //******************************************************************************************************************

    public void addField(String name, String value) {

        _fields.add(new CsvField(name, value));
    }
}