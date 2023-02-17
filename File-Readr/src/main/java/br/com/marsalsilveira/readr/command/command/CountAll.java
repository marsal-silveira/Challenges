package br.com.marsalsilveira.readr.command.command;

import br.com.marsalsilveira.readr.exception.CommandException;
import br.com.marsalsilveira.readr.command.CommandResponse;
import br.com.marsalsilveira.readr.command.ReadrCommand;
import br.com.marsalsilveira.readr.file.model.ReadrFile;
import br.com.marsalsilveira.readr.utils.CollectionUtils;
import br.com.marsalsilveira.readr.utils.StringUtils;
import br.com.marsalsilveira.readr.utils.Strings;

import java.util.List;

/**
 *
 */
public class CountAll implements ReadrCommand {

    //******************************************************************************************************************
    //* Properties
    //******************************************************************************************************************

    public String command() { return Strings.countAll_command; }
    public String description() { return Strings.countAll_description; }
    public String fullDescription() { return Strings.countAll_fullDescription; }

    //******************************************************************************************************************
    //* Constructor
    //******************************************************************************************************************

    public CountAll() { }

    //******************************************************************************************************************
    //* Execution
    //******************************************************************************************************************

    public CommandResponse exec(String input, ReadrFile file) throws CommandException {

        if (!CountAll.Validator.isValid(input)) {

            throw new CommandException(Strings.invalidCommand);
        }

        String result = String.format(Strings.countAll_response, file.count());

        CommandResponse response = new CommandResponse();
        response.addMessage(result);
        return response;
    }

    //******************************************************************************************************************
    //* Validator
    //******************************************************************************************************************

    public static final class Validator {

        // Avoid to create it
        private Validator() { }

        //******************************************************************************************************************
        //* Validation
        //******************************************************************************************************************

        public static boolean isValid(String input) {

            if (StringUtils.isEmpty(input)) {

                return false;
            }

            List<String> parts = CollectionUtils.toList(input.toLowerCase());
            return (parts.size() == 2)
                && (parts.get(0).equals("count"))
                && (parts.get(1).equals("*"));
        }
    }
}