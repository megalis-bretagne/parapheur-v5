@karate-function
Feature: UI tenant lib

    Scenario: Suppression d'une entité
        Given assert exists("//app-header") == true
            And click(ui.locator.header['Administration'])
        #Then waitFor(ui.element.breadcrumb("Administration / Informations serveur"))

        When click("{^}Entités")
        Then waitFor(ui.element.breadcrumb("Administration / Entités"))

        When input("//input[@placeholder='Rechercher une entité']", tenant)
            And click("//td//*[contains(text(),'" + tenant + "')]//ancestor::tr//button[@title='Supprimer']")
            And waitFor("//input[@id='confirmTenantNameInput']")
            And input("//input[@id='confirmTenantNameInput']", tenant)
            And click("//button[contains(@title, 'Supprimer définitivement')]")
            And waitForEnabled(ui.locator.button("Fermer")).click()
        Then waitFor(ui.element.breadcrumb("Administration / Entités"))
            And waitForResultCount("//tbody//td//*[contains(text(),'" + tenant + "')]", 0)
