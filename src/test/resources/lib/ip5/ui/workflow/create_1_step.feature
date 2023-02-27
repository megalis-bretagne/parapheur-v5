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
    * input(ip5.ui.locator.input("Nom du circuit"), [name, Key.ENTER], 200)
    * waitFor("{^}Ajouter une étape").click()
    * waitFor("{^}Nouvelle étape iparapheur")
    * waitFor("{^}" + type).click()
    * waitFor("{^}Simple").click()
    * input("//*[@id='validatorDeskList']//input[@type='text']", desk)
    * waitFor("//*[contains(@class, 'ng-option')]//*[normalize-space(text())='" + desk + "']/ancestor::*[contains(@class, 'ng-option')]").click()
    * waitForEnabled(ip5.ui.locator.button("Ajouter")).click()
    * waitForEnabled(ip5.ui.locator.button("Créer le circuit")).click()
    * ip.pause(1)
    * eval if(exists(ip5.ui.locator.button("Créer le circuit")) === true) waitForEnabled(ip5.ui.locator.button("Créer le circuit")).click()
    * ip.pause(1)

    # Check workflow creation
    * input("//input[contains(@placeholder, 'Rechercher des circuits')]", [name, Key.ENTER], 200)
    * waitFor("//tbody//td[normalize-space(.)='" + type + "']")
