package br.com.marsalsilveira.readr.application;

import br.com.marsalsilveira.readr.application.view.ConsoleView;
import br.com.marsalsilveira.readr.application.view.ReadrView;
import br.com.marsalsilveira.readr.service.ReadrService;
import br.com.marsalsilveira.readr.service.Service;

/**
 * Main class responsible for handle the startup program process...
 */
public final class App {

    public static void main( String[] args ) {

        // Configure app coordinator and start program...
        ReadrView view = new ConsoleView();
        ReadrService service = new Service();

        new Readr(view, service).run();
    }
}