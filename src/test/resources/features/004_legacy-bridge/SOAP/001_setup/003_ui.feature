@legacy-bridge @folder-ui-processing
Feature: Traitement des dossiers

    Background:
        * configure driver = ui.driver.configure
        * driver baseUrl + ui.url.logout

    Scenario Outline: Traitement du dossier "${name}" par lvermillon@legacy-bridge
        * ui.user.login("lvermillon@legacy-bridge", "a123456")
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * match ui.desk.getTileBadges('Vermillon') == { pending: #(pending) }

        * click("{a}Vermillon")
        * waitFor(ui.element.breadcrumb("Accueil / Legacy Bridge / Vermillon / Dossiers à traiter"))
        * click("{a}" + name)

        * waitFor(ui.element.breadcrumb("Accueil / Legacy Bridge / Vermillon / " + name))

        * click("//button[contains(normalize-space(text()), '" + action + "')]")

        * if (action == 'Mail sécurisé') waitFor("//*[@id='mailTo']//input").input("cbuffin+lvermillon-legacy-bridge@libriciel.net")
        * if (action == 'Mail sécurisé') waitFor("//input[@id='mailObject']").input("Mail sécurisé par lvermillon@legacy-bridge (" + name + ")")
        * if (action == 'Mail sécurisé') waitFor("//textarea[@id='mailBody']").input("Veuillez accuser bonne réception...")
        * if (action == 'Mail sécurisé') script("(document.evaluate(\"//button[@title='Envoyer par mail']\", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue).disabled = false")
        * if (action == 'Mail sécurisé') waitFor("//*[contains(normalize-space(text()), 'Envoyer par mail')]/parent::button").click()

        * if (action != 'Mail sécurisé') waitFor("{}Annotation publique").input("Annotation publique lvermillon@legacy-bridge (" + name + ")")
        * if (action != 'Mail sécurisé') waitFor("{}Annotation privée").input("Annotation privée lvermillon@legacy-bridge (" + name + ")")
        * if (action != 'Mail sécurisé') click("{^}Valider")

        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * waitFor(ui.toast.success("action " + action + " sur le dossier " + name + " a été effectuée avec succès"))

        Examples:
            | name                  | action        | pending! |
            | Auto_sign_avec_meta_1 | Rejet         | 10       |
            | Auto_visa_avec_meta_1 | Visa          | 9        |
            | Auto_visa_avec_meta_2 | Rejet         | 8        |
            | Auto_visa_avec_meta_3 | Visa          | 7        |
            | Auto_visa_avec_meta_4 | Rejet         | 6        |
            | PAdES_cachet_1        | Cachet        | 5        |
            | PAdES_cachet_2        | Rejet         | 4        |
            | PAdES_mailsec_1       | Mail sécurisé | 3        |
            | PAdES_mailsec_2       | Rejet         | 3        |
