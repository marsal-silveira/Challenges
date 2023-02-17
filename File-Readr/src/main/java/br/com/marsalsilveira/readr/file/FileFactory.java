package br.com.marsalsilveira.readr.file;

import br.com.marsalsilveira.readr.exception.FileException;
import br.com.marsalsilveira.readr.file.csv.CsvFile;
import br.com.marsalsilveira.readr.file.model.ReadrFile;
import br.com.marsalsilveira.readr.utils.FileUtils;
import br.com.marsalsilveira.readr.utils.Strings;

/**
 *
 */
public final class FileFactory {

    // Avoid to create it
    private FileFactory() { }

    //******************************************************************************************************************
    //* Factory
    //******************************************************************************************************************

    public static ReadrFile createFile(String filePath) throws FileException {

        // check the file
        if (!FileUtils.checkFile(filePath)) {

            throw new FileException(String.format(Strings.fileNotFound, filePath));
        }

        // extract file extension...
        int lastIndex = filePath.lastIndexOf(".");
        if (lastIndex == -1) {

            throw new FileException(String.format(Strings.fileExtensionNotFound, filePath));
        }
        String extension = filePath.substring(lastIndex+1).toLowerCase();

        FileType type;
        try {

            type = FileType.valueOf(extension);
        } catch (Exception e) {

            throw new FileException(Strings.fileInvalidExtension);
        }

        ReadrFile file;
        switch (type) {

            case csv:

                file = new CsvFile(filePath);
                break;

            default:

                throw new FileException(Strings.fileInvalidExtension);
        }
        return file;
    }
}