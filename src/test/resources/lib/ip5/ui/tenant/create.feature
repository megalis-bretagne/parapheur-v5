@karate-function
Feature: UI tenant lib

  Scenario: Ajout d'une entité
    # Move to Admin / Tenants
    * waitFor("//app-header")
    * waitFor(ip5.ui.locator.header['Administration']).click()
    * waitFor("{^}Entités").click()
    * waitFor(ip5.ui.element.breadcrumb("Administration / Entités"))

    # Create tenant
    * waitFor("{^}Créer une nouvelle entité").click()
    * waitFor(ip5.ui.locator.input("Nom")).input(tenant)
    * waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()

#    * eval if(exists(ip5.ui.locator.button("Enregistrer")) === true) waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()


    # Check tenant creation
    * waitFor(ip5.ui.element.breadcrumb("Administration / Entités"))
    * waitFor("//input[@placeholder='Rechercher une entité']").input(tenant)
    * waitFor("//tbody//td//*[contains(text(),'" + tenant + "')]")
