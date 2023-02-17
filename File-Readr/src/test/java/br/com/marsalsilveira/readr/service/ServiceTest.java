package br.com.marsalsilveira.readr.service;

import br.com.marsalsilveira.readr.exception.CommandException;
import br.com.marsalsilveira.readr.exception.FileException;
import br.com.marsalsilveira.readr.utils.Strings;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.util.Arrays;
import java.util.List;

import static org.hamcrest.core.Is.is;

/**
 * Unit test for Service
 */
public class ServiceTest {

    private Service _service;

    @Before
    public void setup() {

        String filePath = "src/test/resources/cidades.csv";

        _service = new Service();
        try {
            _service.setup(filePath);
        } catch (FileException e) {
            e.printStackTrace();
            Assert.fail();
        }
    }

    @Test
    public void testCommands() {

        List<String> commands = Arrays.asList(
                Strings.countAll_fullDescription,
                Strings.countDistinct_fullDescription,
                Strings.filterPropertyValue_fullDescription
        );
        Assert.assertThat(commands , is(_service.commands()));
    }

    @Test
    public void testFields() {

        List<String> fields = Arrays.asList(
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
        Assert.assertThat(fields , is(_service.fields()));
    }

    @Test
    public void testExecCommandCountAll() {

        try {
            String response = String.format(Strings.countAll_response, 5565);
            Assert.assertEquals(response, _service.execCommand("count *").messages().get(0));
            Assert.assertEquals(response, _service.execCommand(" CoUnt  *").messages().get(0));
        } catch (CommandException e) {
            Assert.fail();
        }
    }

    @Test
    public void testExecCommandCountDistinct() {

        try {
            String response = String.format(Strings.countDistinct_response, 27, "uf");
            Assert.assertEquals(response, _service.execCommand("count distinct uf").messages().get(0));
            Assert.assertEquals(response, _service.execCommand(" CoUnt  DisTinCt Uf").messages().get(0));
        } catch (CommandException e) {
            Assert.fail();
        }
    }

    @Test
    public void testExecCommandFilterPropertyValue() {

        try {
            Assert.assertEquals(String.format(Strings.filterPropertyValue_response, 1, "name", "são josé"), _service.execCommand("filter name são josé").messages().get(0));
            Assert.assertEquals(String.format(Strings.filterPropertyValue_response, 1, "name", "SÃO JOSÉ"), _service.execCommand("filter name SÃO JOSÉ").messages().get(0));
            Assert.assertEquals(String.format(Strings.filterPropertyValue_response, 1, "name", "sao jose"), _service.execCommand("filter name sao jose").messages().get(0));
            Assert.assertEquals(String.format(Strings.filterPropertyValue_response, 1, "name", "SAO JOSE"), _service.execCommand("filter name SAO JOSE").messages().get(0));
            Assert.assertEquals(String.format(Strings.filterPropertyValue_response, 1, "name", "sÃo JoSe"), _service.execCommand("  fILTer  namE sÃo    JoSe  ").messages().get(0));
        } catch (CommandException e) {
            Assert.fail();
        }
    }

    @Test(expected = CommandException.class)
    public void testExecCommandInvalidCommandException() throws CommandException {

        _service.execCommand("[count *]");
    }
}