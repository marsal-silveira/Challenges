package br.com.marsalsilveira.readr.command.command;

import br.com.marsalsilveira.readr.command.CommandResponse;
import br.com.marsalsilveira.readr.command.ReadrCommand;
import br.com.marsalsilveira.readr.exception.CommandException;
import br.com.marsalsilveira.readr.file.model.ReadrField;
import br.com.marsalsilveira.readr.file.model.ReadrFile;
import br.com.marsalsilveira.readr.utils.CollectionUtils;
import br.com.marsalsilveira.readr.utils.StringUtils;
import br.com.marsalsilveira.readr.utils.Strings;

import java.util.List;
import java.util.stream.Collectors;

/**
 *
 */
public class CountDistinct implements ReadrCommand {

    //******************************************************************************************************************
    //* Properties
    //******************************************************************************************************************

    public String command() { return Strings.countDistinct_command; }
    public String description() { return Strings.countDistinct_description; }
    public String fullDescription() { return Strings.countDistinct_fullDescription; }

    //******************************************************************************************************************
    //* Constructor
    //******************************************************************************************************************

    public CountDistinct() { }

    //******************************************************************************************************************
    //* Execution
    //******************************************************************************************************************

    public CommandResponse exec(String input, ReadrFile file) throws CommandException {

        if (!CountDistinct.Validator.isValid(input)) {

            throw new CommandException(Strings.emptyCommand);
        }

        List<String> parts = CollectionUtils.toList(input.toLowerCase());

        // check field...

        if (parts.size() > 3) {

            // join all fields parts into another one. eg. `name` and `uf`
            String fields = StringUtils.toString(parts, 2);
            throw new CommandException(String.format(Strings.countDistinct_tooManyParams, fields));
        }

        // check if field is valid...
        String fieldName = parts.size() == 3 ? parts.get(2).toLowerCase() : null;
        if (StringUtils.isEmpty(fieldName)) {

            throw new CommandException(Strings.countDistinct_fieldParamNotFound);
        }
        if (!file.fields().contains(fieldName)) {

            throw new CommandException(String.format(Strings.countDistinct_fieldNotFound, parts.get(2)));
        }

        int count = file.records()
                .stream()
                .map(record -> record.fieldByName(fieldName))
                .map(ReadrField::value)
                .distinct()
                .collect(Collectors.toList())
                .size();
        String result = String.format(Strings.countDistinct_response, count, fieldName);

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
            return (parts.size() >= 2)
                && (parts.get(0).equals("count"))
                && (parts.get(1).equals("distinct"));
        }
    }
}