@karate-function
Feature: UI tenant lib

  Scenario: Suppression d'une entité
    # Move to Admin / tenants
    * eval if (exists("//app-header") == true) click(ip5.ui.locator.header['Administration'])
    * waitFor("{^}Entités").click()
    * waitFor("{^}Gestion des entités")

    # Delete tenant
    * input("//input[@placeholder='Rechercher une entité']", tenant)
    * waitFor("//td//*[contains(text(),'" + tenant + "')]//ancestor::tr//button[@title='Supprimer']").click()
    * waitFor("//input[@id='confirmTenantNameInput']")
    * input("//input[@id='confirmTenantNameInput']", tenant)
    * waitFor("//button[contains(@title, 'Supprimer définitivement')]").click()
    * waitForEnabled(ip5.ui.locator.button("Fermer")).click()
    * waitFor("{^}Gestion des entités")

    # Check delete
    * waitForResultCount("//tbody//td//*[contains(text(),'" + tenant + "')]", 0)
