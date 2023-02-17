package br.com.marsalsilveira.readr.command.command;

import br.com.marsalsilveira.readr.exception.CommandException;
import br.com.marsalsilveira.readr.file.FileMock;
import br.com.marsalsilveira.readr.utils.Strings;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

/**
 * Unit test for FilterPropertyValue Command.
 */
public class FilterPropertyValueTest {

    private FilterPropertyValue _filterPropertyValue;

    @Before
    public void setup() {

        _filterPropertyValue = new FilterPropertyValue();
    }

    @Test
    public void testProperties() {

        Assert.assertEquals(Strings.filterPropertyValue_command, _filterPropertyValue.command());
        Assert.assertEquals(Strings.filterPropertyValue_description, _filterPropertyValue.description());
        Assert.assertEquals(Strings.filterPropertyValue_fullDescription, _filterPropertyValue.fullDescription());
    }

    @Test
    public void testValidation() {

        Assert.assertTrue(FilterPropertyValue.Validator.isValid("filter name palhoça"));
        Assert.assertTrue(FilterPropertyValue.Validator.isValid(" filter  name Palhoca "));
        Assert.assertTrue(FilterPropertyValue.Validator.isValid(" filter  name sao jose dos pinhais"));
        Assert.assertTrue(FilterPropertyValue.Validator.isValid("filter name"));
        Assert.assertTrue(FilterPropertyValue.Validator.isValid("filter nome"));
        Assert.assertFalse(FilterPropertyValue.Validator.isValid("count *"));
    }

    @Test
    public void testExecOK() {

        try {

            Assert.assertEquals(String.format(Strings.filterPropertyValue_response, 1, "name", "Agrolândia"), _filterPropertyValue.exec("filter name Agrolândia", new FileMock()).messages().get(0));
            Assert.assertEquals(String.format(Strings.filterPropertyValue_response, 1, "name", "agrolândia"), _filterPropertyValue.exec("filter name agrolândia", new FileMock()).messages().get(0));
            Assert.assertEquals(String.format(Strings.filterPropertyValue_response, 1, "name", "AGROLÂNDIA"), _filterPropertyValue.exec("filter name AGROLÂNDIA", new FileMock()).messages().get(0));
            Assert.assertEquals(String.format(Strings.filterPropertyValue_response, 0, "name", "são josé"), _filterPropertyValue.exec("filter name são josé", new FileMock()).messages().get(0));
        } catch (CommandException e) {
            e.printStackTrace();
            Assert.fail();
        }
    }

    @Test(expected = CommandException.class)
    public void testExecFail() throws CommandException {

        _filterPropertyValue.exec("filter name", new FileMock());
    }
}