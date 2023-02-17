package br.com.marsalsilveira.readr.file.model;

import br.com.marsalsilveira.readr.utils.CollectionUtils;
import br.com.marsalsilveira.readr.utils.StringUtils;

import java.util.List;

/**
 *
 */
public interface ReadrRecord {

    //******************************************************************************************************************
    //* Properties
    //******************************************************************************************************************

    List<ReadrField> fields();

    //******************************************************************************************************************
    //* Utils
    //******************************************************************************************************************

    default void addField(ReadrField field) {

        fields().add(field);
    }

    default ReadrField fieldByName(String fieldName) {

        if (CollectionUtils.isEmpty(fields()) || StringUtils.isEmpty(fieldName)) {

            return null;
        }

        return fields()
                .stream()
                .filter(field -> field.name().toLowerCase().equals(fieldName.toLowerCase()))
                .findFirst()
                .orElse(null);
//                .orElseThrow(CommandException::new);
    }

    default String valuesToString() {

        return fields()
                .stream()
                .map(field -> field.value())
                .reduce("", (v1, v2) -> v1 + (v1.equals("") ? "" : ", ") + v2);
    }
}