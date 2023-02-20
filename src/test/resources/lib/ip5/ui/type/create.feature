@karate-function
Feature: UI type lib

  Scenario: Ajout d'un type

    Given assert exists("//app-header") == true
    And click(ip5.ui.locator.header['Administration'])
    When ip5.ui.admin.selectTenant(tenant)
    And click("{^}Typologie des dossiers")
    Then waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Typologie des dossiers"))
    When click("{^}Créer un type")
    And input(ip5.ui.locator.input("Nom"), name)
    And input(ip5.ui.locator.input("Description"), description)
    When click("{^}Protocole et format de signature")
    * ip.pause(5)
    And input("#protocolInput input", protocol)
    And click("//*[@id='protocolInput']//*[contains(@class, 'ng-option ')]")
    And input("#popupSigningFormatInput input", format)
    And click("//*[@id='popupSigningFormatInput']//*[contains(@class, 'ng-option ')]")
    And input("{^}Ville de signature", ville)
    When click("{^}Tampon de signature")
    And if (stamp === true) click("//*[text()='Afficher']")
    When waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()
    Then waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Typologie des dossiers"))
    And input("//input[contains(@placeholder, 'Rechercher des types')]", name)
    And waitFor("//tbody//td[contains(text(),'" + name + "')]")
