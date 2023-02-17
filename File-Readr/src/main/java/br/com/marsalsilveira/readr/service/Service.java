package br.com.marsalsilveira.readr.service;

import br.com.marsalsilveira.readr.exception.CommandException;
import br.com.marsalsilveira.readr.exception.FileException;
import br.com.marsalsilveira.readr.command.CommandFactory;
import br.com.marsalsilveira.readr.command.CommandResponse;
import br.com.marsalsilveira.readr.command.ReadrCommand;
import br.com.marsalsilveira.readr.file.FileFactory;
import br.com.marsalsilveira.readr.file.model.ReadrFile;

import java.util.List;
import java.util.stream.Collectors;

/**
 *
 */
public final class Service implements ReadrService {

    //******************************************************************************************************************
    //* Properties
    //******************************************************************************************************************

    private ReadrFile _file = null;

    //******************************************************************************************************************
    //* Constructor
    //******************************************************************************************************************

    public Service() {}

    //******************************************************************************************************************
    //* Setup | Assert
    //******************************************************************************************************************

    public void setup(String filePath) throws FileException {

        _file = FileFactory.createFile(filePath);
    }

    private void assertInitialized() {

        if (_file == null) {

            throw new RuntimeException("Service must be fully initialized before use it. Please call `Service.setup(filePath)`.");
        }
    }

    //******************************************************************************************************************
    //* Service
    //******************************************************************************************************************

    public List<String> commands() {

        this.assertInitialized();

        // get all available command and parse it to string (full description)
        return CommandFactory.commands().stream().map(ReadrCommand::fullDescription).collect(Collectors.toList());
    }

    public List<String> fields() {

        this.assertInitialized();

        return _file.fields();
    }

    public CommandResponse execCommand(String input) throws CommandException {

        this.assertInitialized();

        ReadrCommand command = CommandFactory.command(input);
        return command.exec(input, _file);
    }
}