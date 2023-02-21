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
    * input(ip5.ui.locator.input("Nom"), tenant)
    * waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()

    # Check tenant creation
    * waitFor(ip5.ui.element.breadcrumb("Administration / Entités"))
    * input("//input[@placeholder='Rechercher une entité']", tenant)
    * waitFor("//tbody//td//*[contains(text(),'" + tenant + "')]")
