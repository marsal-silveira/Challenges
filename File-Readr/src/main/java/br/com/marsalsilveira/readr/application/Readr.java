package br.com.marsalsilveira.readr.application;

import br.com.marsalsilveira.readr.application.view.ReadrView;
import br.com.marsalsilveira.readr.exception.CommandException;
import br.com.marsalsilveira.readr.service.ReadrService;
import br.com.marsalsilveira.readr.command.CommandResponse;
import br.com.marsalsilveira.readr.utils.FileUtils;
import br.com.marsalsilveira.readr.utils.Strings;

import java.util.concurrent.TimeUnit;

/**
 * Main app controller responsible to control all app flow.
 */
final class Readr {

    //******************************************************************************************************************
    //* Properties
    //******************************************************************************************************************

    private final ReadrView _view;
    private final ReadrService _service;

    // TODO: hardcoded... this can be replaced by another file
    private final String _defaultFilePath = "resources/cidades.csv";
    private final String _defaultFileName = "cidades.csv";

    //******************************************************************************************************************
    //* Constructor
    //******************************************************************************************************************

    Readr(ReadrView view, ReadrService service) {

        _view = view;
        _service = service;
    }

    //******************************************************************************************************************
    //* Run
    //******************************************************************************************************************

    void run() {

        try {

            // show about and get file path to continue...
            this.showAbout();

            String filePath = this.getFilePath();
            if (FileUtils.checkFile(filePath)) {

                // initialize `service` with filePath and continue...
                try {
                    _service.setup(filePath);

                    // get file fields and show all available fields and command to user...
                    String fileFields = _service.fields().stream().reduce("", (v1, v2) -> v1 + (v1.equals("") ? "" : Strings.lineBreak + Strings.tab) + v2);
                    if (filePath.equals(_defaultFilePath)) {

                        _view.output();
                        _view.output(String.format(Strings.selectDefaultFile, _defaultFileName, fileFields));
                    }
                    else {

                        _view.output();
                        _view.output(String.format(Strings.selectCustomFile, fileFields));
                    }

                    // now print all available commands and wait for user input
                    this.waitForCommand();

                } catch (Exception e) {

                    _view.outputError(e.getLocalizedMessage());
                }
            }
            else {

                _view.outputError(String.format(Strings.fileNotFound, filePath));
            }
        } finally {

            // TODO: [Workaround] I don't known why but sometimes `_view` messes up all messages... so we put this `sleep` to synchronize it
            this.synchronize();

            _view.output(Strings.bye);
            _view.close();
        }
    }

    private void waitForCommand() {

        String input;
        do {

            // list all available command and wait for user input (command)
            this.showCommands();
            input = _view.input();

            // if user type `exit` just close program...
            if (!input.equals(Strings.exitCommand)) {

                try {

                    CommandResponse response = _service.execCommand(input);
                    _view.output(response.toString());
                } catch (CommandException e) {

                    _view.outputError(e.getLocalizedMessage());
                }
            }

            // TODO: [Workaround] I don't known why but sometimes `_view` messes up all messages... so we put this `sleep` to synchronize it
            this.synchronize();
        } while (!input.equals(Strings.exitCommand));
    }

    private void showAbout() {

        _view.output(Strings.about);
    }

    private String getFilePath() {

        _view.output();
        _view.output();
        _view.output(String.format(Strings.inputFilePath, _defaultFileName));

        String filePath = _view.input();
        filePath = filePath.equals("") ? _defaultFilePath : filePath;

        return filePath;
    }

    private void showCommands() {

        _view.output();
        _view.output();
        String commands = _service.commands().stream().reduce("", (v1, v2) -> v1 + (v1.equals("") ? "" : "\n" + Strings.tab) + v2);
        _view.output(String.format(Strings.commands, commands));

    }

    //******************************************************************************************************************
    //* Utils
    //******************************************************************************************************************

    private void synchronize() {

        try {
            TimeUnit.MILLISECONDS.sleep(250);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}