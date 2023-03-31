@karate-function
Feature: UI type lib

  Scenario: Ajout d'un type
    # Move to Admin / {tenant} / Typology
    * waitFor("//app-header")
    * waitFor(ip5.ui.locator.header['Administration']).click()
    * ip5.ui.admin.selectTenant(tenant)
    * waitFor("{^}Typologie des dossiers").click()
    * waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Typologie des dossiers"))

    # Create type
    * waitFor("{^}Créer un type").click()
    * input(ip5.ui.locator.input("Nom"), name)
    * input(ip5.ui.locator.input("Description"), description)
    * waitFor("{^}Protocole et format de signature").click()
    * waitFor("#protocolInput input").input(protocol)
    * waitFor("//*[@id='protocolInput']//*[contains(@class, 'ng-option ')]").click()
    * input("#popupSigningFormatInput input", format)
    * waitFor("//*[@id='popupSigningFormatInput']//*[contains(@class, 'ng-option ')]").click()
    * input("{^}Ville de signature", ville)
    * waitFor("{^}Tampon de signature").click()
    * eval if (stamp === true) waitFor("//*[text()='Afficher']").click()
    * waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()

#    * eval if(exists(ip5.ui.locator.button("Enregistrer")) === true) waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()


    # Check type creation
    * waitFor("//input[contains(@placeholder, 'Rechercher des types')]").input(name)
    * waitFor("//tbody//td[contains(text(),'" + name + "')]")
