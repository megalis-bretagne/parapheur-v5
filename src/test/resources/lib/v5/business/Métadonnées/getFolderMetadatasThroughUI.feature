@business @metadonnees @folder @ignore
Feature: ...

    Scenario: ...
        * configure driver = ui.driver.configure
        * driver baseUrl + ui.url.logout
        * ui.user.login(__arg.username, 'a123456')

        * click("{a}" + __arg.desktop)
        * click("//span[contains(@class, 'badge badge-" + __arg.state + " desk-badge')]")

          # Filtre sur le nom du dossier
        * click(ui.locator.tray.filter.toggle)
        * input(ui.locator.input('Titre'), __arg.folder)
        * click(ui.locator.tray.filter.apply)

        * click("{a}" + __arg.folder)

        * waitFor(ui.element.breadcrumb("Accueil / " + __arg.tenant + " / " + __arg.desktop + " / " + __arg.folder))

        * def getMetadatas =
"""
function() {
    var actual = {},
        content,
        idx,
        label,
        lines,
        inputType,
        xpath = "//strong[text()='Métadonnées']/parent::div/parent::div/parent::div//app-step-metadata-list/div",
        inputXpath;

    lines = karate.sizeOf(locateAll(xpath));

    for (idx = 1;idx <= lines;idx++) {
        label = text(xpath + "[position() = " + idx + "]/label").trim();

        content = null;
        if (exists(xpath + "[position() = " + idx + "]/app-metadata-input//ng-select") === true) {
            inputXpath = xpath + "[position() = " + idx + "]/app-metadata-input//ng-select";
            content = text(inputXpath + "//span[contains(@class, 'ng-value-label')]").trim();//@fixme: la valeur ? ou reformater ?
            if (content !== "") {
                inputType = ip.metadatas.types[ip.metadatas.inverse[label]];
                if (inputType === "BOOLEAN") {
                    if (content === "Oui") {
                        content = true;
                    } else if (content === "Non") {
                        content = false;
                    }
                } else if (inputType === "DATE") {
                    content = content.replace(/^(..)\/(..)\/(....)$/, "$3-$2-$1");
                } else if (inputType === "FLOAT") {
                    content = parseFloat(content);
                } else if (inputType === "INTEGER") {
                    content = parseInt(content, 10);
                }
            }
        } else if (exists(xpath + "[position() = " + idx + "]/app-metadata-input//input") === true) {
            inputXpath = xpath + "[position() = " + idx + "]/app-metadata-input//input";
            content = value(inputXpath).trim();
            if (content !== "") {
                inputType = ip.metadatas.types[ip.metadatas.inverse[label]];
                if (inputType === "FLOAT") {
                    content = parseFloat(content);
                } else if (inputType === "INTEGER") {
                    content = parseInt(content, 10);
                }
            }
        } else {
            karate.fail('Champ non trouvé via "' + xpath + "[position() = " + idx + "]/app-metadata-input//ng-select" + '" ou "' + xpath + "[position() = " + idx + "]/app-metadata-input//input" + '"');
        }

        actual[ip.metadatas.inverse[label]] = content;
    }

    return actual;
}
"""
      #* waitFor("//strong[text()='Métadonnées']");
      * def metadatas = getMetadatas()
