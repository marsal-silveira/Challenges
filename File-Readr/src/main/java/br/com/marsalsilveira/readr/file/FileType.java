package br.com.marsalsilveira.readr.file;

/**
 *
 */
public enum FileType {

    csv(".csv");

    private String _extension;
    public String extension() { return _extension; }

    FileType(String extension) {

        _extension = extension;
    }
}
