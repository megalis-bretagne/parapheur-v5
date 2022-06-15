@karate-function
Feature: UI tenant lib

    Scenario: Ajout d'une entité
        Given assert exists("//app-header") == true
            And click("//app-header//*[@routerLink='/admin']")
        Then waitFor(ui.element.breadcrumb("Administration / Informations serveur"))

        When click("{^}Entités")
        Then waitFor(ui.element.breadcrumb("Administration / Entités"))

        When click("{^}Créer une nouvelle entité")
            And input(ui.locator.input("Nom"), tenant)
            And waitForEnabled(ui.locator.button("Enregistrer")).click()
        Then waitFor(ui.element.breadcrumb("Administration / Entités"))
            And waitFor(ui.toast.success("entité " + tenant + " a été créée avec succès"))
            And input("//input[@placeholder='Rechercher une entité']", tenant)
            And waitFor("//tbody//td//*[contains(text(),'" + tenant + "')]")
