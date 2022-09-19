@karate-function
Feature: UI type lib

    Scenario: Ajout d'un type
        Given assert exists("//app-header") == true
            And click(ip5.ui.locator.header['Administration'])
        #Then waitFor(ip5.ui.element.breadcrumb("Administration / Informations serveur"))

        When ip5.ui.admin.selectTenant(tenant)
            And click("{^}Typologie des dossiers")
        Then waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Typologie des dossiers"))

        When click("{^}Créer un type")
            And input(ip5.ui.locator.input("Nom"), name)
            And input(ip5.ui.locator.input("Description"), description)

        When click("{^}Protocole et format de signature")
            # @todo: wait for element
            * ip.pause(5)
            # Protocole
            And input("#protocolInput input", protocol)
            And click("//*[@id='protocolInput']//*[contains(@class, 'ng-option ')]")
            # Format de signature
            And input("#popupSigningFormatInput input", format)
            And click("//*[@id='popupSigningFormatInput']//*[contains(@class, 'ng-option ')]")
            And input("{^}Ville de signature", ville)

        When click("{^}Tampon de signature")
            And if (stamp === true) click("//*[text()='Afficher']")

        When waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()
        Then waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Typologie des dossiers"))
            And waitFor(ip5.ui.toast.success("Le type " + name + " a été créé avec succès"))
            And input("//input[contains(@placeholder, 'Rechercher des types')]", name)
            And waitFor("//tbody//td[contains(text(),'" + name + "')]")
