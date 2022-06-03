@karate-function
Feature: UI subtype lib

    Scenario: Ajout d'un sous-type
        Given assert exists("//app-header") == true
            And click("//app-header//*[@routerLink='/admin']")
        Then waitFor(ui.element.breadcrumb("Administration / Informations serveur"))

        When ui.admin.selectTenant(tenant)
            And click("{^}Typologie des dossiers")
        Then waitFor(ui.element.breadcrumb("Administration / " + tenant + " / Typologie des dossiers"))

        When click("//tbody//td[contains(text(),'" + type + "')]/ancestor::tr//button[@title='Ajouter un sous-type']")
            And input("#popupNameInput", name)
            And input("{^}Description", description)

        When click("#ngb-nav-3")
            And pause(5)
            And waitForEnabled("#selectValidationWorkflow input").input(workflow)
            And waitForEnabled("//*[contains(@class, 'ng-option ')]").click()
            And waitForEnabled(ui.locator.button("Enregistrer")).click()
            And pause(5)
        Then waitFor(ui.element.breadcrumb("Administration / " + tenant + " / Typologie des dossiers"))
            And waitFor(ui.toast.success("Le sous-type " + name + " a été créé avec succès"))
            And waitFor("//tbody//td[contains(text(),'" + name + "')]")
