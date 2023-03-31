@karate-function
Feature: UI subtype lib

  Scenario: Ajout d'un sous-type
    # Move to Admin / {tenant} / Users
    * waitFor("//app-header")
    * waitFor(ip5.ui.locator.header['Administration']).click()
    * ip5.ui.admin.selectTenant(tenant)
    * waitFor("{^}Typologie des dossiers").click()
    * waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Typologie des dossiers"))

    # Create subtype
    * waitFor("//tbody//td[contains(text(),'" + type + "')]/ancestor::tr//button[@title='Ajouter un sous-type']").click()
    * input("#popupNameInput", [name, Key.ENTER], 200)
    * input("{^}Description", [description, Key.ENTER], 200)
    * waitFor("#ngb-nav-3").click()

    * waitForEnabled("#selectValidationWorkflow input").input(workflow)
    * waitForEnabled("//*[contains(@class, 'ng-option ')]").click()
    * waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()

#    * eval if(exists(ip5.ui.locator.button("Enregistrer")) === true) waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()


    # Check user creation
    * waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Typologie des dossiers"))
    * waitFor(ip5.ui.toast.success("Le sous-type " + name + " a été créé avec succès"))
    * waitFor("//input[contains(@placeholder, 'Rechercher des types')]").input([name, Key.ENTER], 200)
    * waitFor("//tbody//td[contains(text(),'" + name + "')]")
