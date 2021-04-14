Feature: Mot de passe oublié

    Background:
        * configure driver = ui.driver.configure
        # force logout between each scenario
        * driver baseUrl + ui.url.logout

    Scenario: Accéder à la page de mot de passe oublié
        Given driver baseUrl
        And waitFor('form')
        When click('{^*}Forgot Password?')
        Then match html('body') contains 'Forgot Your Password?'

    Scenario: Retour à la page de connexion après avoir accédé à la page de mot de passe oublié
        Given driver baseUrl
            And waitFor('form')
        When click('{^*}Forgot Password?')
            And match html('body') contains 'Forgot Your Password?'
            # @fixme
            And click('a:first-of-type')
        Then match html('body') contains 'Bienvenue sur la page de connexion iParapheur'
