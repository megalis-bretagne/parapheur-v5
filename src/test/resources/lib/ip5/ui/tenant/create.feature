@karate-function
Feature: UI tenant lib

  Scenario: Ajout d'une entité
    # Move to Admin / tenants
    * eval if (exists("//app-header") === true) click(ip5.ui.locator.header['Administration'])
    * waitFor("//*[text() = 'Entités']").click()

    # Create entity
    * waitFor("//*[text() = 'Créer une nouvelle entité']").click()
    * input(ip5.ui.locator.input("Nom"), tenant)
    * waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()

    # Check creation
    * waitFor(ip5.ui.element.breadcrumb("Administration / Entités"))
    * input("//input[@placeholder='Rechercher une entité']", tenant)
    * waitFor("//tbody//td//*[contains(text(),'" + tenant + "')]")
