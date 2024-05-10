@karate-function
Feature: UI workflow lib

  Scenario: Ajout d'un circuit à 1 étape
    # Move to Admin / {tenant} / Workflows
    * waitFor("//app-header")
    * waitFor(ip5.ui.locator.header['Administration']).click()
    * ip5.ui.admin.selectTenant(tenant)
    * waitFor("{^}Circuits").click()
    * waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Circuits"))

    # Create workflow
    * waitFor("{^}Créer un circuit").click()
    * input(ip5.ui.locator.input("Nom du circuit"), [name, Key.TAB], 200)
    * waitFor("//i[contains(@class, 'fa fa-plus-circle')]").click()
    * waitFor("{^}Enregistrer")
    * waitFor("{^}" + type).click()
    * waitFor("{^}Étape simple").click()
    * input("//*[@id='validatorDeskList']//input[@type='text']", desk)
    * waitFor("//*[contains(@class, 'ng-option')]//*[normalize-space(text())='" + desk + "']/ancestor::*[contains(@class, 'ng-option')]").click()
    * waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()
    * waitForEnabled(ip5.ui.locator.button("Créer le circuit")).click()

#    * eval if(exists(ip5.ui.locator.button("Créer le circuit")) === true) waitForEnabled(ip5.ui.locator.button("Créer le circuit")).click()


    # Check workflow creation
    * waitFor("//input[contains(@placeholder, 'Rechercher des circuits')]").input([name, Key.ENTER], 200)
    * waitFor("//tbody//td[normalize-space(.)='" + type + "']")
