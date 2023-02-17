package br.com.marsalsilveira.readr.command.command;

import br.com.marsalsilveira.readr.exception.CommandException;
import br.com.marsalsilveira.readr.file.FileMock;
import br.com.marsalsilveira.readr.utils.Strings;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

/**
 * Unit test for CountAll Command.
 */
public class CountAllTest {

    private CountAll _countAll;

    @Before
    public void setup() {

        _countAll = new CountAll();
    }

    @Test
    public void testProperties() {

        Assert.assertEquals(Strings.countAll_command, _countAll.command());
        Assert.assertEquals(Strings.countAll_description, _countAll.description());
        Assert.assertEquals(Strings.countAll_fullDescription, _countAll.fullDescription());
    }

    @Test
    public void testValidation() {

        Assert.assertTrue(CountAll.Validator.isValid("count *"));
        Assert.assertTrue(CountAll.Validator.isValid(" cOuNt  * "));
        Assert.assertFalse(CountAll.Validator.isValid("count *;"));
    }

    @Test
    public void testExecOK() {

        try {

            String expected = String.format(Strings.countAll_response, 10);
            Assert.assertEquals(expected, _countAll.exec("count *", new FileMock()).toString());
            Assert.assertEquals(expected, _countAll.exec(" cOuNt   * ", new FileMock()).toString());
        } catch (CommandException e) {
            e.printStackTrace();
            Assert.fail();
        }
    }

    @Test(expected = CommandException.class)
    public void testExecFail() throws CommandException {

        _countAll.exec("[count *]", new FileMock());
    }
}