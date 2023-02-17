package br.com.marsalsilveira.readr.command;

import br.com.marsalsilveira.readr.exception.CommandException;
import br.com.marsalsilveira.readr.command.command.CountAll;
import br.com.marsalsilveira.readr.command.command.CountDistinct;
import br.com.marsalsilveira.readr.command.command.FilterPropertyValue;
import org.junit.Assert;
import org.junit.Test;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import static org.hamcrest.core.Is.is;

/**
 * Unit test for CommandFactoryTest.
 */
public class CommandFactoryTest {

    @Test
    public void testCommands() {

        List<Class<? extends ReadrCommand>> commandsExpected = Arrays.asList(
                CountAll.class,
                CountDistinct.class,
                FilterPropertyValue.class
        );
        List<Class<? extends ReadrCommand>> commandsResponse = CommandFactory.commands().stream().map(ReadrCommand::getClass).collect(Collectors.toList());
        Assert.assertThat(commandsExpected , is(commandsResponse));
    }

    @Test
    public void testCommandCountAll() {

        try {
            Assert.assertEquals(CountAll.class, CommandFactory.command("count *").getClass());
            Assert.assertEquals(CountAll.class, CommandFactory.command(" CoUnt  *").getClass());
        } catch (CommandException e) {
            Assert.fail();
        }
    }

    @Test
    public void testExecCommandCountDistinct() {

        try {
            Assert.assertEquals(CountDistinct.class, CommandFactory.command("count distinct uf").getClass());
            Assert.assertEquals(CountDistinct.class, CommandFactory.command(" CoUnt  DisTinCt Uf").getClass());
        } catch (CommandException e) {
            Assert.fail();
        }
    }

    @Test
    public void testExecCommandFilterPropertyValue() {

        try {
            Assert.assertEquals(FilterPropertyValue.class, CommandFactory.command("filter name são josé").getClass());
            Assert.assertEquals(FilterPropertyValue.class, CommandFactory.command("filter name SÃO JOSÉ").getClass());
            Assert.assertEquals(FilterPropertyValue.class, CommandFactory.command("filter name sao jose").getClass());
            Assert.assertEquals(FilterPropertyValue.class, CommandFactory.command("filter name SAO JOSE").getClass());
            Assert.assertEquals(FilterPropertyValue.class, CommandFactory.command("  fILTer  namE sÃo    JoSe  ").getClass());
        } catch (CommandException e) {
            Assert.fail();
        }
    }

    @Test(expected = CommandException.class)
    public void testExecCommandInvalidCommandException() throws CommandException {

        CommandFactory.command("[count *]");
    }
}