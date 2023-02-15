@karate-function
Feature: UI workflow lib

  Scenario: Ajout d'un circuit à 1 étape
    # Move to Admin / tenants / Workflows
    * eval if (exists("//app-header") === true) click(ip5.ui.locator.header['Administration'])
    * ip5.ui.admin.selectTenant(tenant)
    * click("//*[text() = 'Circuits']")

    # Create workflow
    * waitFor("//*[text() = 'Créer un circuit']").click()
    * input(ip5.ui.locator.input("Nom du circuit"), name)
    * waitFor("//*[text() = 'Ajouter une étape']").click()
    * waitFor("//*[text() = 'Nouvelle étape iparapheur']")
    * waitFor("//*[text() = '" + type + "']").click()
    * waitFor("//*[text() = 'Simple']").click()
    * input("//*[@id='validatorDeskList']//input[@type='text']", desk)
    * waitFor("//*[contains(@class, 'ng-option')]//*[normalize-space(text())='" + desk + "']/ancestor::*[contains(@class, 'ng-option')]".click())
    * waitForEnabled(ip5.ui.locator.button("Ajouter")).click()
    * waitForEnabled(ip5.ui.locator.button("Créer le circuit")).click()

    # Check creation
    * input("//input[contains(@placeholder, 'Rechercher des circuits')]", name)
    * waitFor("//tbody//td[normalize-space(.)='" + type + "']")
