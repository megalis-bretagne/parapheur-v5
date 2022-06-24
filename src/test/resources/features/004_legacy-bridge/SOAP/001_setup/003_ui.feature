@legacy-bridge @folder-ui-processing
Feature: Traitement des dossiers

    Background:
        * configure driver = ui.driver.configure
        * driver baseUrl + ui.url.logout

    Scenario Outline: Traitement du dossier "${name}" par lvermillon@legacy-bridge
        * ui.user.login("lvermillon@legacy-bridge", "a123456")
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * match ui.desk.getTileBadges('Vermillon') == {pending: #(pending)}

        * click("{a}Vermillon")
        * waitFor(ui.element.breadcrumb("Accueil / Legacy Bridge / Vermillon / Dossiers en cours"))
        * click("{a}" + name)

        * waitFor(ui.element.breadcrumb("Accueil / Legacy Bridge / Vermillon / " + name))

        * click("//button[contains(normalize-space(text()), '" + action + "')]")
        * waitFor("{}Annotation publique").input("Annotation publique lvermillon@legacy-bridge (" + name + ")")
        * waitFor("{}Annotation privée").input("Annotation privée lvermillon@legacy-bridge (" + name + ")")
        * click("{^}Valider")
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * waitFor(ui.toast.success("action " + action + " sur le dossier " + name + " a été effectuée avec succès"))

        Examples:
            | name                  | action | pending! |
            | Auto_visa_avec_meta_1 | Visa   | 4        |
            | Auto_visa_avec_meta_2 | Rejet  | 3        |
            | Auto_visa_avec_meta_3 | Visa   | 2        |
            | Auto_visa_avec_meta_4 | Rejet  | 1        |
