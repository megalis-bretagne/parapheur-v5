@karate-function
Feature: UI tenant lib

    Scenario: Ajout d'une entité
        Given assert exists("//app-header") == true
            And click(ip5.ui.locator.header['Administration'])
        #Then waitFor(ip5.ui.element.breadcrumb("Administration / Informations serveur"))

        When click("{^}Entités")
        Then waitFor(ip5.ui.element.breadcrumb("Administration / Entités"))

        When click("{^}Créer une nouvelle entité")
            And input(ip5.ui.locator.input("Nom"), tenant)
            And waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()
        Then waitFor(ip5.ui.element.breadcrumb("Administration / Entités"))
            And waitFor(ip5.ui.toast.success("L'entité " + tenant + " a été créée avec succès"))
            And input("//input[@placeholder='Rechercher une entité']", tenant)
            And waitFor("//tbody//td//*[contains(text(),'" + tenant + "')]")
