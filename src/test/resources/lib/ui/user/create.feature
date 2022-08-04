@karate-function
Feature: UI user lib

    Scenario: Ajout d'un utilisateur
        Given assert exists("//app-header") == true
            And click(ui.locator.header['Administration'])
        #Then waitFor(ui.element.breadcrumb("Administration / Informations serveur"))

        When ui.admin.selectTenant(tenant)
            And click("{^}Utilisateurs")
        Then waitFor(ui.element.breadcrumb("Administration / " + tenant + " / Utilisateurs"))

        When click("{^}Créer un utilisateur")
            And input("#editInfoUserNameInput", username)
            And input("#editInfoLastNameInput", lastName)
            And input(ui.locator.input("Prénom"), firstName)
            And input(ui.locator.input("E-mail"), email)
            And input(ui.locator.input("Nouveau mot de passe"), password)
            And input(ui.locator.input("Confirmer le mot de passe"), password)
            And click("//a[text()='Droits']")
            And click("//div[@class='modal-body']//label[contains(@class, 'btn')][position()=" + ui.admin.getRoleIndex(role) + "]")
            And waitForEnabled(ui.locator.button("Enregistrer")).click()
        Then waitFor(ui.element.breadcrumb("Administration / " + tenant + " / Utilisateurs"))
            #And waitFor(ui.toast.success("utilisateur " + firstName + " " + lastName + " a été créé avec succès"))
            And input("//input[contains(@placeholder, 'Rechercher un utilisateur')]", username)
            And waitFor("//tbody//td//*[contains(text(),'" + username + "')]")
