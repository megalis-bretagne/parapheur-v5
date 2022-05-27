@karate-function
Feature: UI type lib

    Scenario: Ajout d'un type
        Given assert exists("//app-header") == true
            And click("//app-header//*[@routerLink='/admin']")
        Then waitFor(ui.element.breadcrumb("Administration / Informations serveur"))

        When ui.admin.selectTenant(tenant)
            And click("{^}Typologie des dossiers")
        Then waitFor(ui.element.breadcrumb("Administration / " + tenant + " / Typologie des dossiers"))

        When click("{^}Créer un type")
            And input(ui.locator.input("Nom"), name)
            And input(ui.locator.input("Description"), description)

        When click("{^}Protocole et format de signature")
            # @fixme: wait for element
            * pause(5)
            # Protocole
            And input("#protocolInput input", protocol)
            And click("//*[@id='protocolInput']//*[contains(@class, 'ng-option ')]")
            # Format de signature
            And input("#popupSigningFormatInput input", format)
            And click("//*[@id='popupSigningFormatInput']//*[contains(@class, 'ng-option ')]")

            And input("{^}Ville de signature", ville)

        # @todo: SSI PAdES, etc...
        When click("{^}Tampon de signature")
            And click("{^}Afficher")

        When waitForEnabled(ui.locator.button("Enregistrer")).click()
        Then waitFor(ui.element.breadcrumb("Administration / " + tenant + " / Typologie des dossiers"))
          And waitFor(ui.toast.success("Le type " + name + " a été créé avec succès"))
          And waitFor("//tbody//td[contains(text(),'" + name + "')]")
