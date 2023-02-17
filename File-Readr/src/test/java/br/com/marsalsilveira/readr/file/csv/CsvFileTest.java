package br.com.marsalsilveira.readr.file.csv;

import br.com.marsalsilveira.readr.exception.FileException;
import br.com.marsalsilveira.readr.file.FileType;
import org.junit.Assert;
import org.junit.Test;

import java.util.Arrays;
import java.util.List;

import static org.hamcrest.core.Is.is;

/**
 * Unit test for CsvFile.
 */
public class CsvFileTest {

    private static List<String> _fields = Arrays.asList(
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

    @Test
    public void testSetupFileFull() {

        String filePath = "src/test/resources/cidades.csv";
        try {
            CsvFile file = new CsvFile(filePath);

            // name, path, type
            Assert.assertEquals("cidades.csv", file.name());
            Assert.assertEquals(filePath, file.path());
            Assert.assertEquals(FileType.csv, file.type());
            Assert.assertFalse(file.isEmpty());

            // Fields and records
            Assert.assertThat(_fields, is(file.fields()));
            Assert.assertEquals(5565, file.count());
            Assert.assertEquals(5565, file.records().size());
        } catch (FileException e) {
            e.printStackTrace();
            Assert.fail();
        }
    }

    @Test
    public void testSetupFileWithoutRecords() {

        String filePath = "src/test/resources/cidades_without_records.csv";
        try {
            CsvFile file = new CsvFile(filePath);

            // name, path, type
            Assert.assertEquals("cidades_without_records.csv", file.name());
            Assert.assertEquals(filePath, file.path());
            Assert.assertEquals(FileType.csv, file.type());
            Assert.assertTrue(file.isEmpty());

            // Fields and records
            Assert.assertThat(_fields, is(file.fields()));
            Assert.assertEquals(0, file.count());
            Assert.assertEquals(0, file.records().size());
        } catch (FileException e) {
            e.printStackTrace();
            Assert.fail();
        }
    }

    @Test(expected = FileException.class)
    public void testSetupFileNotFound() throws FileException {

        String filePath = "src/test/resources/cidades_fake.csv";
        new CsvFile(filePath);
    }

    @Test(expected = FileException.class)
    public void testSetupFileEmpty() throws FileException {

        String filePath = "src/test/resources/cidades_empty.csv";
        new CsvFile(filePath);
    }

    @Test(expected = FileException.class)
    public void testSetupFileWithoutExtension() throws FileException {

        String filePath = "src/test/resources/cidades_without_extension";
        new CsvFile(filePath);
    }

    @Test(expected = FileException.class)
    public void testSetupFileInvalidExtension() throws FileException {

        String filePath = "src/test/resources/cidades.txt";
        new CsvFile(filePath);
    }
}
