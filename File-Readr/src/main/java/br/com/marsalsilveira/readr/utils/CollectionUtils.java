package br.com.marsalsilveira.readr.utils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

/**
 * Collection utils class.
 */
public final class CollectionUtils {

    // Avoid to create it
    private CollectionUtils() {}

    //******************************************************************************************************************
    //* Utils
    //******************************************************************************************************************

    /**
     * Check if the given collection is null or empty.
     *
     * @param collection The collection to be checked.
     *
     * @return true if the collection is null or empty. False otherwise.
     */
    public static boolean isEmpty(Collection<?> collection) {

        return (collection == null) || (collection.isEmpty());
    }

    /**
     * Check if the given collection is not null and not empty.
     * It'j just a wrapper to <code>!CollectionUtils.isEmpty(collection)</code>.
     *
     * @param collection The collection to be checked.
     *
     * @return true if the collection is not null and not empty. False otherwise.
     */
    public static boolean isNotEmpty(Collection<?> collection) {

        return !CollectionUtils.isEmpty(collection);
    }

    /**
     * Extract all words from `str` param and return a List<String> List with them.
     *
     * @param str The string to be parsed.
     *
     * @return List<String> with string content splited by ' '
     */
    public static List<String> toList(String str) {

        if (StringUtils.isEmpty(str)) {

            return new ArrayList<>();
        }

        // remove all empty spaces between words and create a new list with them
        str = str.trim().replaceAll("\\s+", " ");
        return Arrays.asList(str.split(" "));
    }
}