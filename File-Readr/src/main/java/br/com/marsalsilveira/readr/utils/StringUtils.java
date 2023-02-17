package br.com.marsalsilveira.readr.utils;

import java.text.Normalizer;
import java.util.Collection;
import java.util.stream.Collectors;

/**
 * String utils class.
 */
public final class StringUtils {

    // Avoid to create it
    private StringUtils() {}

    //******************************************************************************************************************
    //* Utils
    //******************************************************************************************************************

    /**
     * Check if the given string is null or empty.
     *
     * @param str The string to be checked.
     *
     * @return true if the string is null or empty. False otherwise.
     */
    public static boolean isEmpty(String str) {

        return (str == null) || (str.trim().isEmpty());
    }

    /**
     * Check if the given string is not null and not empty.
     * It'j just a wrapper to <code>!StringUtils.isEmpty(str)</code>.
     *
     * @param str The string to be checked.
     *
     * @return true if the string is not null and not empty. False otherwise.
     */
    public static boolean isNotEmpty(String str) {

        return !StringUtils.isEmpty(str);
    }

    /**
     * Removes diacritics (~= accents) from a string. The case will not be altered.
     *
     * For instance, 'à' will be replaced by 'a'.
     *
     * Note that ligatures will be left as is.
     *
     * StringUtils.stripAccents(null) = null
     * StringUtils.stripAccents("") = ""
     * StringUtils.stripAccents("control") = "control"
     * StringUtils.stripAccents("éclair") = "eclair"
     *
     * @param input - String to be stripped
     *
     * @return input text with diacritics removed
     */
    public static String stripAccents(String input) {

        if (input == null) {

            return null;
        }

        input = Normalizer.normalize(input, Normalizer.Form.NFD);
//        input = input.replaceAll("[\\p{InCombiningDiacriticalMarks}]", "");
        input = input.replaceAll("[^\\p{ASCII}]", "");
        return input;
    }

    public static String toString(Collection<String> collection) {

        return StringUtils.toString(collection, 0);
    }

    public static String toString(Collection<String> collection, int skip) {

        if (CollectionUtils.isEmpty(collection)) {

            return null;
        }

        Collection<String> c = (skip > 0) ? collection.stream().skip(skip).collect(Collectors.toList()) : collection;
        return c.stream().reduce("", (v1, v2) -> v1 + (v1.equals("") ? "" : " ") + v2);
    }
}