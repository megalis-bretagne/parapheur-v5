@karate-function
Feature: UI workflow lib

    Scenario: Ajout d'un circuit à 1 étape
        Given assert exists("//app-header") == true
            And click("//app-header//*[@routerLink='/admin']")
        Then waitFor(ui.element.breadcrumb("Administration / Informations serveur"))

        When ui.admin.selectTenant(tenant)
            And click("{^}Circuits")
        Then waitFor(ui.element.breadcrumb("Administration / " + tenant + " / Circuits"))

        When click("{^}Créer un circuit")
            And input(ui.locator.input("Nom du circuit"), name)
            And click("{^}Ajouter une étape")
            And waitFor("{^}Nouvelle étape i-Parapheur")
            And click("{^}" + type)
            And click("{^}Simple")
            And input("//*[@id='validatorDeskList']//input[@type='text']", desk)
            And click("//*[contains(@class, 'ng-option')]//*[normalize-space(text())='" + desk + "']/ancestor::*[contains(@class, 'ng-option')]")
            And waitForEnabled(ui.locator.button("Ajouter")).click()
            And waitForEnabled(ui.locator.button("Créer le circuit")).click()
        #Then waitFor(ui.toast.success("Le circuit " + name + " a été créé avec succès"))
        # @fixme IP: Le circuit undefined a été créé avec succès
        #* karate.log(script("//div[contains(@class, 'toast-')]", "_.outerHTML"))
            And waitFor("//tbody//td[normalize-space(.)='" + type + "']")
