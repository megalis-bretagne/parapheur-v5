@karate-function
Feature: UI user lib
    Background:
        * configure cookies = null

    # @info: on accepte les valeurs par défaut des notifications à la connexion (si besoin)
    Scenario: Connexion
        Given driver baseUrl
            And waitFor("{^}Veuillez saisir vos identifiants de connexion")
            And waitFor("form")
            And input(ip5.ui.locator.input("Identifiant"), [username, Key.ENTER], 200)
            And input(ip5.ui.locator.input("Mot de passe"), [password, Key.ENTER], 200)
        When submit().click(ip5.ui.locator.button("Se connecter"))
        Then waitFor("{^}iparapheur")

        * def firstConnection = exists("//*[text()='Première connexion sur le iparapheur']")
        * eval if (firstConnection === true) waitFor("//div[contains(concat(' ', @class, ' '), ' modal-content ')]" + ip5.ui.locator.button("Enregistrer")).click()
        * eval if (firstConnection === true) waitFor(ip5.ui.toast.success("Vos préférences de notification ont été modifiées avec succès.")).click()
