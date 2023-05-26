@business @ip5 @legacy-bridge @folder-ui-processing
Feature: Traitement des dossiers

    Background:
        # * configure driver = ip.ui.driver.configure
        * driver baseUrl + ip5.ui.url.logout

    Scenario Outline: Traitement du dossier "${name}" par lvermillon@legacy-bridge
        * ip5.ui.user.login("lvermillon@legacy-bridge", "a123456a123456")
        #* match ip5.ui.desk.getTileBadges('Vermillon') == { pending: #(pending) }

        * waitFor(ip5.ui.element.breadcrumb("Accueil / Legacy Bridge / Vermillon / Dossiers à traiter"))
        * waitFor("{a}" + name).click()

        * waitFor(ip5.ui.element.breadcrumb("Accueil / Legacy Bridge / Vermillon / " + name))

        * waitFor("//*[contains(normalize-space(text()), '" + action + "')]/ancestor-or-self::button").click()

        * if (action == 'Mail sécurisé') waitFor("//*[@id='mailTo']//input").input("cbuffin+lvermillon-legacy-bridge@libriciel.net")
        * if (action == 'Mail sécurisé') waitFor("//input[@id='mailObject']").input("Mail sécurisé par lvermillon@legacy-bridge (" + name + ")")
        * if (action == 'Mail sécurisé') waitFor("//textarea[@id='mailBody']").input("Veuillez accuser bonne réception...")
        * if (action == 'Mail sécurisé') script("(document.evaluate(\"//app-send-by-mail-popup//button[@title='Mail sécurisé']\", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue).disabled = false")
        * if (action == 'Mail sécurisé') waitFor("//app-send-by-mail-popup//*[contains(normalize-space(text()), 'Mail sécurisé')]/parent::button").click()

        * if (action != 'Mail sécurisé') ip5.ui.folder.annotate.both("lvermillon@legacy-bridge", action, name)
        * if (action != 'Mail sécurisé') waitFor("{^}Valider").click()
        # Pastell may take around 7/8 seconds to respond
        * if (action == 'Mail sécurisé') ip.pause(10)
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Legacy Bridge / Vermillon / Dossiers à traiter"))
        * if (action != 'Mail sécurisé') waitFor(ip5.ui.toast.success("action " + action + " sur le dossier " + name + " a été effectuée avec succès"))

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
