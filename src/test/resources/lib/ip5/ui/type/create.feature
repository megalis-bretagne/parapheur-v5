@karate-function
Feature: UI type lib

  Scenario: Ajout d'un type
    # Move to Admin / tenants / Typology
    * eval if (exists("//app-header") == true) click(ip5.ui.locator.header['Administration'])
    * ip5.ui.admin.selectTenant(tenant)
    * waitFor("{^}Typologie des dossiers").click()

    # Create type
    * waitFor("{^}Créer un type").click()
    * input(ip5.ui.locator.input("Nom"), name)
    * input(ip5.ui.locator.input("Description"), description)
    * waitFor("{^}Protocole et format de signature").click()
    * ip.pause(5)
    * input("#protocolInput input", protocol)
    * waitFor("//*[@id='protocolInput']//*[contains(@class, 'ng-option ')]").click()
    * input("#popupSigningFormatInput input", format)
    * waitFor("//*[@id='popupSigningFormatInput']//*[contains(@class, 'ng-option ')]").click()
    * input("{^}Ville de signature", ville)
    * waitFor("{^}Tampon de signature").click()
    * eval if (stamp === true) waitFor("{^}Afficher").click()

    # Check creation
    * waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()
    * waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Typologie des dossiers"))
    * waitFor(ip5.ui.toast.success("Le type " + name + " a été créé avec succès"))
    * input("//input[contains(@placeholder, 'Rechercher des types')]", name)
    * waitFor("//tbody//td[contains(text(),'" + name + "')]")
