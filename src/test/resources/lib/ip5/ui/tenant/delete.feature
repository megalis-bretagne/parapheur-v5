@karate-function
Feature: UI tenant lib

  Scenario: Suppression d'une entité
    # Move to Admin / Tenants
    * waitFor("//app-header")
    * waitFor(ip5.ui.locator.header['Administration']).click()
    * waitFor("{^}Entités").click()
    * waitFor(ip5.ui.element.breadcrumb("Administration / Entités"))

    # Delete tenant
    * input("//input[@placeholder='Rechercher une entité']", tenant)
    * waitFor("//td//*[contains(text(),'" + tenant + "')]//ancestor::tr//button[@title='Supprimer']").click()
    * waitFor("//input[@id='confirmTenantNameInput']")
    * input("//input[@id='confirmTenantNameInput']", tenant)
    * waitFor("//button[contains(@title, 'Supprimer définitivement')]").click()
    * waitForEnabled(ip5.ui.locator.button("Fermer")).click()

    # Check tenant deletion
    * waitFor(ip5.ui.element.breadcrumb("Administration / Entités"))
    * waitForResultCount("//tbody//td//*[contains(text(),'" + tenant + "')]", 0)
