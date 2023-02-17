@karate-function
Feature: UI user lib

  Background:
    * configure cookies = null
    * driver baseUrl

  Scenario: Connexion
    * waitFor("{^}Veuillez saisir vos identifiants de connexion")
    * waitFor("form")
    * input(ip5.ui.locator.input("Identifiant"), username)
    * input(ip5.ui.locator.input("Mot de passe"), password)
    * submit().click(ip5.ui.locator.button("Se connecter"))
    * waitFor("{^}iparapheur")

    # On accepte les valeurs par défaut des notifications à la connexion (si besoin)
    * def firstConnection = exists("//*[text()='Première connexion sur le iparapheur']")
    * eval if (firstConnection === true) click("//div[contains(concat(' ', @class, ' '), ' modal-content ')]" + ip5.ui.locator.button("Enregistrer"))
    * eval if (firstConnection === true) waitFor(ip5.ui.toast.success("Vos préférences de notification ont été modifiées avec succès.")).click()
