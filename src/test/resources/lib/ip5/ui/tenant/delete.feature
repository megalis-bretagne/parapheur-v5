@karate-function
Feature: UI tenant lib

  Scenario: Suppression d'une entité
    Given assert exists("//app-header") == true
    And click(ip5.ui.locator.header['Administration'])
    When click("{^}Entités")
    Then waitFor("{^}Gestion des entités")
    When input("//input[@placeholder='Rechercher une entité']", tenant)
    And click("//td//*[contains(text(),'" + tenant + "')]//ancestor::tr//button[@title='Supprimer']")
    And waitFor("//input[@id='confirmTenantNameInput']")
    And input("//input[@id='confirmTenantNameInput']", tenant)
    And click("//button[contains(@title, 'Supprimer définitivement')]")
    And waitForEnabled(ip5.ui.locator.button("Fermer")).click()
    Then waitFor("{^}Gestion des entités")
    And waitForResultCount("//tbody//td//*[contains(text(),'" + tenant + "')]", 0)
