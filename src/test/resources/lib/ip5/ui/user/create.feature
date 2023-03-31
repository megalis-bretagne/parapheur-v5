@karate-function
Feature: UI user lib

  Scenario: Ajout d'un utilisateur
    # Move to Admin / {tenant} / Users
    * waitFor("//app-header")
    * waitFor(ip5.ui.locator.header['Administration']).click()
    * ip5.ui.admin.selectTenant(tenant)
    * waitFor("{^}Utilisateurs").click()
    * waitFor(ip5.ui.element.breadcrumb("Administration / " + tenant + " / Utilisateurs"))

    # Create user
    * waitFor("{^}Créer un utilisateur").click()
    * input("#editInfoUserNameInput", [username, Key.ENTER], 200)
    * waitUntil('#editInfoUserNameInput', "_.value == '" + username + "'")
    * input("#editInfoLastNameInput", [lastName, Key.ENTER], 200)
    * waitUntil('#editInfoLastNameInput', "_.value == '" + lastName + "'")
    * input(ip5.ui.locator.input("Prénom"), [firstName, Key.ENTER], 200)
    * waitUntil(ip5.ui.locator.input("Prénom"), "_.value == '" + firstName + "'")
    * input(ip5.ui.locator.input("E-mail"), [email, Key.ENTER], 200)
    * waitUntil(ip5.ui.locator.input("E-mail"), "_.value == '" + email + "'")
    * input(ip5.ui.locator.input("Nouveau mot de passe"), [password, Key.ENTER], 200)
    * input(ip5.ui.locator.input("Confirmer le mot de passe"), [password, Key.ENTER], 200)
    * waitFor("//a[text()='Droits']").click()
    * waitFor("//div[@class='modal-body']//label[contains(@class, 'btn')][position()=" + ip5.ui.admin.getRoleIndex(role) + "]").click()
    * ip.pause(1)
    * waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()

#    * eval if(exists(ip5.ui.locator.button("Enregistrer")) === true) waitForEnabled(ip5.ui.locator.button("Enregistrer")).click()


    # Check user creation
    * waitFor("//input[contains(@placeholder, 'Rechercher un utilisateur')]").input(username)
    * waitFor("//tbody//td//*[contains(text(),'" + username + "')]")
