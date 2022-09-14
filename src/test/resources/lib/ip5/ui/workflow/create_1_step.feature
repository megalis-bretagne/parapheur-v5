@karate-function
Feature: UI workflow lib

    Scenario: Ajout d'un circuit à 1 étape
        Given assert exists("//app-header") == true
            And click(ip5.ui.locator.header['Administration'])
        #Then waitFor(ip5.ui.element.breadcrumb("Administration / Informations serveur"))

        When ip5.ui.admin.selectTenant(tenant)
            And click("{^}Circuits")
        Then waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Circuits"))

        When click("{^}Créer un circuit")
            And input(ip5.ui.locator.input("Nom du circuit"), name)
            And click("{^}Ajouter une étape")
            And waitFor("{^}Nouvelle étape iparapheur")
            And click("{^}" + type)
            And click("{^}Simple")
            And input("//*[@id='validatorDeskList']//input[@type='text']", desk)
            And click("//*[contains(@class, 'ng-option')]//*[normalize-space(text())='" + desk + "']/ancestor::*[contains(@class, 'ng-option')]")
            And waitForEnabled(ip5.ui.locator.button("Ajouter")).click()
            And waitForEnabled(ip5.ui.locator.button("Créer le circuit")).click()
        #Then waitFor(ip5.ui.toast.success("Le circuit " + name + " a été créé avec succès"))
        # @fixme IP: Le circuit undefined a été créé avec succès
        #* karate.log(script("//div[contains(@class, 'toast-')]", "_.outerHTML"))
            And input("//input[contains(@placeholder, 'Rechercher des circuits')]", name)
            And waitFor("//tbody//td[normalize-space(.)='" + type + "']")
