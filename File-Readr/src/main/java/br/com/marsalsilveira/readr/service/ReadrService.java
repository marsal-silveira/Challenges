package br.com.marsalsilveira.readr.service;

import br.com.marsalsilveira.readr.exception.CommandException;
import br.com.marsalsilveira.readr.exception.FileException;
import br.com.marsalsilveira.readr.command.CommandResponse;

import java.util.List;

/**
 *
 */
public interface ReadrService {

    //******************************************************************************************************************
    //* Service
    //******************************************************************************************************************

    void setup(String filePath) throws FileException;

    List<String> commands();
    List<String> fields();
    CommandResponse execCommand(String input) throws CommandException;
}