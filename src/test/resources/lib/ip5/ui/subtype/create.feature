@karate-function
Feature: UI subtype lib

    Scenario: Ajout d'un sous-type
        Given assert exists("//app-header") == true
            And click(ip5.ui.locator.header['Administration'])
        #Then waitFor(ip5.ui.element.breadcrumb("Administration / Informations serveur"))

        When ip5.ui.admin.selectTenant(tenant)
            And click("{^}Typologie des dossiers")
        Then waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Typologie des dossiers"))

        When click("//tbody//td[contains(text(),'" + type + "')]/ancestor::tr//button[@title='Ajouter un sous-type']")
            And input("#popupNameInput", name)
            And input("{^}Description", description)

        When click("#ngb-nav-3")
            And ip.pause(5)
            And waitForEnabled("#selectValidationWorkflow input").input(workflow)
            And waitForEnabled("//*[contains(@class, 'ng-option ')]").click()
            And waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()
            And ip.pause(5)
        Then waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Typologie des dossiers"))
            And waitFor(ip5.ui.toast.success("Le sous-type " + name + " a été créé avec succès"))
            And input("//input[contains(@placeholder, 'Rechercher des types')]", name)
            And waitFor("//tbody//td[contains(text(),'" + name + "')]")
