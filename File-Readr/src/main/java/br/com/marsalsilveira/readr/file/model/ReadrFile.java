package br.com.marsalsilveira.readr.file.model;

import br.com.marsalsilveira.readr.file.FileType;
import br.com.marsalsilveira.readr.utils.CollectionUtils;
import br.com.marsalsilveira.readr.utils.StringUtils;

import java.util.List;

/**
 *
 */
public interface ReadrFile {

    //******************************************************************************************************************
    //* Properties
    //******************************************************************************************************************

    FileType type();

    String name();
    String path();

    List<String> fields();
    List<ReadrRecord> records();
    long count();

    //******************************************************************************************************************
    //* Utils
    //******************************************************************************************************************

    default boolean isEmpty() {

        return this.count() == 0;
    }

    default String fieldByName(String fieldName) {

        if (CollectionUtils.isEmpty(fields()) || StringUtils.isEmpty(fieldName)) {

            return null;
        }

        return fields()
                .stream()
                .filter(field -> field.toLowerCase().equals(fieldName.toLowerCase()))
                .findFirst()
                .orElse(null);
//                .orElseThrow(CommandException::new);
    }

    default String fieldsToString() {

        return fields()
                .stream()
                .reduce("", (v1, v2) -> v1 + (v1.equals("") ? "" : ", ") + v2);
    }
}