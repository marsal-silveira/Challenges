package br.com.marsalsilveira.readr.file.csv;

import br.com.marsalsilveira.readr.exception.FileException;
import br.com.marsalsilveira.readr.file.FileType;
import br.com.marsalsilveira.readr.file.model.ReadrFile;
import br.com.marsalsilveira.readr.file.model.ReadrRecord;
import br.com.marsalsilveira.readr.utils.FileUtils;
import br.com.marsalsilveira.readr.utils.Strings;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

/**
 *
 */
public final class CsvFile implements ReadrFile {

    //******************************************************************************************************************
    //* Properties
    //******************************************************************************************************************

    private final FileType _type;
    public FileType type() { return _type; }

    private final String _name;
    public String name() { return _name; }

    private final String _path;
    public String path() { return _path; }

    private final long _count;
    public long count() { return _count; }

    private final List<String> _fields;
    public List<String> fields() { return _fields; }

    public List<ReadrRecord> records() {  return this.getRecords(); }

    //******************************************************************************************************************
    //* Constructor
    //******************************************************************************************************************

    public CsvFile(String path) throws FileException {

        // first of all... validate if path is valid and has a valid csv file
        this.validate(path);

        // TODO: check this... maybe can be moved to another utils class (String, File)
        int nameIndex = path.lastIndexOf("/") + 1;
        String name = path.substring(nameIndex).toLowerCase();

        _type = FileType.csv;
        _name = name;
        _path = path;
        _fields = this.getFields();
        _count = this.getRecordsCount();
    }

    //******************************************************************************************************************
    //* Validate
    //******************************************************************************************************************

    private void validate(String path) throws FileException {

        // check the file
        if (!FileUtils.checkFile(path)) {

            throw new FileException(String.format(Strings.fileNotFound, path));
        }

        // path is valid... now we check if it isn't empty
        File file = new File(path);
        if (file.length() == 0) {

            throw new FileException(Strings.fileEmpty);
        }
    }

    //******************************************************************************************************************
    //* Fields and records
    //******************************************************************************************************************

    private long getRecordsCount() throws FileException {

        long count;
        try (Stream<String> lines = Files.lines(Paths.get(_path))) {

            count = lines
                    .skip(1)
                    .count();
        } catch (IOException e) {

            throw new FileException("Error extracting file content (records).");
        }
        return count;
    }

    private List<String> getFields() throws FileException {

        List<String> result = new ArrayList<>();

        // extract first line (fields model) and all records
        try (BufferedReader reader = Files.newBufferedReader(Paths.get(_path))) {

            String firstLine = reader.readLine();

            List<String> fieldNames = Arrays.asList(firstLine.split(Strings.comma));
            for (String fieldName : fieldNames) {

                result.add(fieldName.trim());
            }
        } catch (IOException ex) {

            throw new FileException("Error extracting file fields (model).");
        }

        return result;
    }

    private List<ReadrRecord> getRecords() {

        List<ReadrRecord> records = new ArrayList<>();

        // check if file is empty...
        File file = new File(_path);
        if (file.length() == 0) {

            return records;
        }

        // extract all records (except first line)
        try (BufferedReader reader = Files.newBufferedReader(file.toPath())) {

            // skip first line
            reader.lines().skip(1).forEach(line -> {

                CsvRecord record = new CsvRecord();
                int index = -1;

                List<String> values = Arrays.asList(line.split(Strings.comma));
                for (String value : values) {

                    index++;
                    record.addField(_fields.get(index), value.trim());
                }

                records.add(record);
            });
        } catch (IOException e) {

            // ignore this exception because all validation must be done before...
            return new ArrayList<>();
        }

        return records;
    }
}