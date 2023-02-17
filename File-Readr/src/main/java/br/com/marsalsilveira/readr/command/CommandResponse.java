package br.com.marsalsilveira.readr.command;

import br.com.marsalsilveira.readr.utils.Strings;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
// TODO: maybe this class can get more complexity... returning some extra info for each request...
public class CommandResponse {

    //******************************************************************************************************************
    //* Properties
    //******************************************************************************************************************

    private final List<String> _messages;
    public List<String> messages() { return _messages; }

    //******************************************************************************************************************
    //* Constructor
    //******************************************************************************************************************

    public CommandResponse() {

        _messages = new ArrayList<>();
    }

    //******************************************************************************************************************
    //* Utils
    //******************************************************************************************************************

    public void addMessage(String message) {

        _messages.add(message);
    }

    @Override
    public String toString() {

        return messages().stream().reduce("", (v1, v2) -> v1 + (v1.equals("") ? "" : Strings.lineBreak) + v2);
    }
}