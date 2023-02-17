@karate-function
Feature: UI subtype lib

  Scenario: Ajout d'un sous-type
    # Move to Admin / tenants / Typology
    * eval if (exists("//app-header") == true) click(ip5.ui.locator.header['Administration'])
    * ip5.ui.admin.selectTenant(tenant)
    * waitFor("{^}Typologie des dossiers").click()

    # Create subtype
    * click("//*[contains(text(),'" + type + "')]/ancestor::tr//button[@title='Ajouter un sous-type']")
    * input("#popupNameInput", name)
    * input("{^}Description", description)
    * click("#ngb-nav-3")
    * ip.pause(5)
    * waitForEnabled("#selectValidationWorkflow input").input(workflow)
    * waitForEnabled("//*[contains(@class, 'ng-option ')]").click()
    * waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()
    * ip.pause(5)

    # Check creation
    * waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Typologie des dossiers"))
    * input("//input[contains(@placeholder, 'Rechercher des types')]", name)
    * waitFor("//tbody//td[contains(text(),'" + name + "')]")
