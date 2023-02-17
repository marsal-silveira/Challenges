package br.com.marsalsilveira.readr.command.command;

import br.com.marsalsilveira.readr.command.CommandResponse;
import br.com.marsalsilveira.readr.command.ReadrCommand;
import br.com.marsalsilveira.readr.exception.CommandException;
import br.com.marsalsilveira.readr.file.model.ReadrFile;
import br.com.marsalsilveira.readr.file.model.ReadrRecord;
import br.com.marsalsilveira.readr.utils.CollectionUtils;
import br.com.marsalsilveira.readr.utils.StringUtils;
import br.com.marsalsilveira.readr.utils.Strings;

import java.util.List;
import java.util.stream.Collectors;

/**
 *
 */
public class FilterPropertyValue implements ReadrCommand {

    //******************************************************************************************************************
    //* Properties
    //******************************************************************************************************************

    public String command() { return Strings.filterPropertyValue_command; }
    public String description() { return Strings.filterPropertyValue_description; }
    public String fullDescription() { return Strings.filterPropertyValue_fullDescription; }

    //******************************************************************************************************************
    //* Constructor
    //******************************************************************************************************************

    public FilterPropertyValue() { }

    //******************************************************************************************************************
    //* Execution
    //******************************************************************************************************************

    public CommandResponse exec(String input, ReadrFile file) throws CommandException {

        if (!FilterPropertyValue.Validator.isValid(input)) {

            throw new CommandException(Strings.invalidCommand);
        }

        // check if field and value are valid...
        List<String> parts = CollectionUtils.toList(input);

        // check if the field name is valid...
        String fieldName = parts.get(1).toLowerCase();
        if (!file.fields().contains(fieldName)) {

            throw new CommandException(String.format(Strings.filterPropertyValue_fieldNotFound, parts.get(1)));
        }

        // join all parts of value filter to another one... eg. `são` `josé` -> `são josé`
        String fieldValue = StringUtils.toString(parts, 2);

        // check if the field value has been given...
        if (StringUtils.isEmpty(fieldValue)) {

            throw new CommandException(Strings.filterPropertyValue_valueParamNotFound);
        }

        List<String> records = file.records()
                .stream()
                .filter(record -> StringUtils.stripAccents(record.fieldByName(fieldName).value()).toLowerCase().equals(StringUtils.stripAccents(fieldValue).toLowerCase()))
                .map(ReadrRecord::valuesToString)
                .collect(Collectors.toList());

        CommandResponse response = new CommandResponse();
        response.addMessage(String.format(Strings.filterPropertyValue_response, records.size(), fieldName, fieldValue));

        if (records.size() > 0) {

            response.addMessage(Strings.lineBreak + file.fieldsToString());
            records.forEach(response::addMessage);
        }

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
                && (parts.get(0).equals("filter"))
                && (StringUtils.isNotEmpty(parts.get(1)));
        }
    }
}