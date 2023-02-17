package br.com.marsalsilveira.readr.command.command;

import br.com.marsalsilveira.readr.exception.CommandException;
import br.com.marsalsilveira.readr.file.FileMock;
import br.com.marsalsilveira.readr.utils.Strings;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

/**
 * Unit test for CountDistinct Command.
 */
public class CountDistinctTest {

    private CountDistinct _countDistinct;

    @Before
    public void setup() {

        _countDistinct = new CountDistinct();
    }

    @Test
    public void testProperties() {

        Assert.assertEquals(Strings.countDistinct_command, _countDistinct.command());
        Assert.assertEquals(Strings.countDistinct_description, _countDistinct.description());
        Assert.assertEquals(Strings.countDistinct_fullDescription, _countDistinct.fullDescription());
    }

    @Test
    public void testValidation() {

        Assert.assertTrue(CountDistinct.Validator.isValid("count distinct uf"));
        Assert.assertTrue(CountDistinct.Validator.isValid(" CoUnt  DisTinCt Uf "));
        Assert.assertTrue(CountDistinct.Validator.isValid("count distinct"));
        Assert.assertTrue(CountDistinct.Validator.isValid("count distinct ufc"));
        Assert.assertTrue(CountDistinct.Validator.isValid("count distinct uf sc"));
        Assert.assertFalse(CountDistinct.Validator.isValid("count *"));
        Assert.assertFalse(CountDistinct.Validator.isValid("count distinc uf sc"));
    }

    @Test
    public void testExecOK() {

        try {

            Assert.assertEquals(String.format(Strings.countDistinct_response, 1, "uf"), _countDistinct.exec("count distinct uf", new FileMock()).toString());
            Assert.assertEquals(String.format(Strings.countDistinct_response, 1, "uf"), _countDistinct.exec(" CoUnt  DisTinCt Uf ", new FileMock()).toString());
            Assert.assertEquals(String.format(Strings.countDistinct_response, 8, "microregion"), _countDistinct.exec("count distinct microregion", new FileMock()).toString());
        } catch (CommandException e) {
            e.printStackTrace();
            Assert.fail();
        }
    }

    @Test(expected = CommandException.class)
    public void testExecFail() throws CommandException {

        _countDistinct.exec("count distinct", new FileMock());
        _countDistinct.exec("count distinct ufc", new FileMock());
        _countDistinct.exec("count distinct uf pr", new FileMock());
    }
}