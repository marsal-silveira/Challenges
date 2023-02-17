package br.com.marsalsilveira.readr.file;

import br.com.marsalsilveira.readr.file.model.ReadrFile;
import br.com.marsalsilveira.readr.file.model.ReadrRecord;
import br.com.marsalsilveira.readr.utils.Strings;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Mock file for test purpose.
 */
public final class FileMock implements ReadrFile {

    //******************************************************************************************************************
    //* Properties
    //******************************************************************************************************************

    public FileType type() { return FileType.csv; }
    public String name() { return "mockFile.csv"; }
    public String path() { return "mockFile.csv"; }
    public long count() { return _lines.size(); }

    private final List<String> _fields;
    public List<String> fields() { return _fields; }

    public List<ReadrRecord> records() { return this.getRecords(); }

    private static List<String> _lines = Arrays.asList(
            "4200051,SC,Abdon Batista,,-51.025272211,-27.6089871233,Abdon Batista,,Curitibanos,Serrana",
            "4200101,SC,Abelardo Luz,,-52.3364823833,-26.5630310224,Abelardo Luz,,Xanxerê,Oeste Catarinense",
            "4200200,SC,Agrolândia,,-49.8256533877,-27.400516588,Agrolandia,,Ituporanga,Vale do Itajaí",
            "4200309,SC,Agronômica,,-49.7183688908,-27.2697161071,Agronomica,,Rio do Sul,Vale do Itajaí",
            "4200408,SC,Água Doce,,-51.5590965553,-27.0040916589,Agua Doce,,Joaçaba,Oeste Catarinense",
            "4200507,SC,Águas de Chapecó,,-52.9872510057,-27.0762129125,Aguas de Chapeco,,Chapecó,Oeste Catarinense",
            "4200556,SC,Águas Frias,,-52.8594194494,-26.880227543,Aguas Frias,,Chapecó,Oeste Catarinense",
            "4200606,SC,Águas Mornas,,-48.8405384028,-27.7065971917,Aguas Mornas,,Tabuleiro,Grande Florianópolis",
            "4200705,SC,Alfredo Wagner,,-49.3438123012,-27.705396332,Alfredo Wagner,,Tabuleiro,Grande Florianópolis",
            "4200754,SC,Alto Bela Vista,,-51.9110368541,-27.4311378753,Alto Bela Vista,,Concórdia,Oeste Catarinense"
    );

    //******************************************************************************************************************
    //* Constructor
    //******************************************************************************************************************

    public FileMock() {

        _fields = this.getFields();
    }

    //******************************************************************************************************************
    //* Fields and records
    //******************************************************************************************************************

    private List<String> getFields() {

        return Arrays.asList(
                "ibge_id",
                "uf",
                "name",
                "capital",
                "lon",
                "lat",
                "no_accents",
                "alternative_names",
                "microregion",
                "mesoregion"
        );
    }

    private List<ReadrRecord> getRecords() {

        List<ReadrRecord> records = new ArrayList<>();

        // extract all records
        for (String line : _lines) {

            RecordMock record = new RecordMock();
            int index = -1;

            List<String> values = Arrays.asList(line.split(Strings.comma));
            for (String value : values) {

                index++;
                record.addField(_fields.get(index), value.trim());
            }

            records.add(record);
        }

        return records;
    }
}