package br.com.marsalsilveira.readr.command;

import br.com.marsalsilveira.readr.exception.CommandException;
import br.com.marsalsilveira.readr.command.command.CountAll;
import br.com.marsalsilveira.readr.command.command.CountDistinct;
import br.com.marsalsilveira.readr.command.command.FilterPropertyValue;
import br.com.marsalsilveira.readr.utils.CollectionUtils;
import br.com.marsalsilveira.readr.utils.StringUtils;
import br.com.marsalsilveira.readr.utils.Strings;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class CommandFactory {

    // Avoid to create it
    private CommandFactory() { }

    //******************************************************************************************************************
    //* Commands
    //******************************************************************************************************************

    public static List<ReadrCommand> commands() {

        List<ReadrCommand> commands = new ArrayList<>();
        commands.add(new CountAll());
        commands.add(new CountDistinct());
        commands.add(new FilterPropertyValue());
        // put here others command...

        return commands;
    }

    public static ReadrCommand command(String input) throws CommandException {

        if (StringUtils.isEmpty(input)) {

            throw new CommandException("Command cannot be empty.");
        }

        if (CountAll.Validator.isValid(input)) {

            return new CountAll();
        }

        if (CountDistinct.Validator.isValid(input)) {

            return new CountDistinct();
        }

        if (FilterPropertyValue.Validator.isValid(input)) {

            return new FilterPropertyValue();
        }

        // get wrong command
        List<String> parts = CollectionUtils.toList(input.toLowerCase());
        String wrongCommand = parts.size() >= 1 ? parts.get(0) : "input";
        throw new CommandException(String.format(Strings.unknownCommad, wrongCommand));
    }
}