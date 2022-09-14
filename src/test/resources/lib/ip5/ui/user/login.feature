@karate-function
Feature: UI user lib
    Background:
        * configure cookies = null

    # @info: on accepte les valeurs par défaut des notifications à la connexion (si besoin)
    Scenario: Connexion
        Given driver baseUrl
            And waitFor("{^}Veuillez saisir vos identifiants de connexion")
            And waitFor("form")
            And input(ip5.ui.locator.input("Identifiant"), username)
            And input(ip5.ui.locator.input("Mot de passe"), password)
        When submit().click(ip5.ui.locator.button("Se connecter"))
        Then waitFor(ip5.ui.element.breadcrumb("Accueil / Bureaux"))
            And waitFor("{^}Bienvenue sur le iparapheur")
            And match html("body") contains "Sélectionnez un bureau pour parcourir ses dossiers"

        * def firstConnection = exists("//*[text()='Première connexion sur le iparapheur']")
        * eval if (firstConnection === true) click("//div[contains(concat(' ', @class, ' '), ' modal-content ')]" + ip5.ui.locator.button("Enregistrer"))
        * eval if (firstConnection === true) waitFor(ip5.ui.toast.success("Vos préférences de notification ont été modifiées avec succès.")).click()
