package br.com.marsalsilveira.readr.utils;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;

/**
 * String utils class.
 */
public final class FileUtils {

    // Avoid to create it
    private FileUtils() {}

    //******************************************************************************************************************
    //* Utils
    //******************************************************************************************************************

    /**
     * Check if the given file path exits as a file.
     *
     * @param filepath The file path to check.
     *
     * @return true if the given file path is a existing file.
     */
    public static boolean checkFile(String filepath) {

        return StringUtils.isNotEmpty(filepath)
            && Files.exists(Paths.get(filepath))
            && FileUtils.checkFile(new File(filepath));
    }

    /**
     * Check if the given file exits.
     *
     * @param file The file to check.
     *
     * @return true if the given file exists and is not a directory. False otherwise.
     */
    public static boolean checkFile(File file) {

        return file != null
            && file.exists()
            && !file.isDirectory();
    }
}