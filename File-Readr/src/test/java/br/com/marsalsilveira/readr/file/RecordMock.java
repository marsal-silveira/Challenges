package br.com.marsalsilveira.readr.file;

import br.com.marsalsilveira.readr.file.csv.CsvField;
import br.com.marsalsilveira.readr.file.model.ReadrField;
import br.com.marsalsilveira.readr.file.model.ReadrRecord;

import java.util.ArrayList;
import java.util.List;

/**
 * Mock record for test purpose.
 */
public class RecordMock implements ReadrRecord {

    //******************************************************************************************************************
    //* Properties
    //******************************************************************************************************************

    private final List<ReadrField> _fields;
    public List<ReadrField> fields() { return _fields; }

    //******************************************************************************************************************
    //* Constructor
    //******************************************************************************************************************

    public RecordMock() {

        _fields = new ArrayList<>();
    }

    //******************************************************************************************************************
    //* Utils
    //******************************************************************************************************************

    public void addField(String name, String value) {

        _fields.add(new CsvField(name, value));
    }
}