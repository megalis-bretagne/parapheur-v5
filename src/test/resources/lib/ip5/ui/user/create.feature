@karate-function
Feature: UI user lib

    Scenario: Ajout d'un utilisateur
        Given assert exists("//app-header") == true
            And click(ip5.ui.locator.header['Administration'])
        #Then waitFor(ip5.ui.element.breadcrumb("Administration / Informations serveur"))

        When ip5.ui.admin.selectTenant(tenant)
            And click("{^}Utilisateurs")
        Then waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Utilisateurs"))

        @parallel=false
        When click("{^}Créer un utilisateur")
            And input("#editInfoUserNameInput", [username, Key.ENTER], 300)
            And waitForText("#editInfoUserNameInput", username)
            And input("#editInfoLastNameInput", [lastName, Key.ENTER], 300)
            And input(ip5.ui.locator.input("Prénom"), [firstName, Key.ENTER], 300)
            And input(ip5.ui.locator.input("E-mail"), [email, Key.ENTER], 300)
            And input(ip5.ui.locator.input("Nouveau mot de passe"), [password, Key.ENTER], 300)
            And input(ip5.ui.locator.input("Confirmer le mot de passe"), [password, Key.ENTER], 300)
            And click("//a[text()='Droits']")
            And click("//div[@class='modal-body']//label[contains(@class, 'btn')][position()=" + ip5.ui.admin.getRoleIndex(role) + "]")
            And waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()
        Then waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Utilisateurs"))
            #And waitFor(ip5.ui.toast.success("utilisateur " + firstName + " " + lastName + " a été créé avec succès"))
            And input("//input[contains(@placeholder, 'Rechercher un utilisateur')]", username)
            And waitFor("//tbody//td//*[contains(text(),'" + username + "')]")
