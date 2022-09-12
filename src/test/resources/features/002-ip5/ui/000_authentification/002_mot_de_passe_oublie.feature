@ip5 @ip-web
Feature: Mot de passe oublié

    Background:
        * configure driver = ui.driver.configure
        # force logout between each scenario
        * driver baseUrl + ui.url.logout

    Scenario: Accéder à la page de mot de passe oublié
        Given driver baseUrl
        And waitFor('form')
        When click('{^*}Mot de passe oublié ?')
        Then match html('body') contains 'Un e-mail va vous être envoyé'

    Scenario: Retour à la page de connexion après avoir accédé à la page de mot de passe oublié
        Given driver baseUrl
            And waitFor('form')
        When click('{^*}Mot de passe oublié ?')
            And match html('body') contains 'Un e-mail va vous être envoyé'
            # @fixme
            And click('a:first-of-type')
        Then match html('body') contains 'Bienvenue sur la page de connexion iparapheur'
