@ip-web
Feature: Connexion

    Background:
        * configure driver = ui.driver.configure
        # force logout between each scenario
        * driver baseUrl + ui.url.logout

    @fixme-ip-web @l10n
        Scenario: Accéder à la page de connexion
        Given driver baseUrl
            And waitFor('form')
        Then match html('body') contains 'Bienvenue sur la page de connexion iParapheur'
            And match html('body') contains 'doLogInInfo'
            And match html('body') contains 'Username or email'
            And match html('body') contains 'Password'
            And match html('body') contains 'Forgot Password?'
            And match html('body') contains 'Log In'

    @fixme-ip-web @l10n
        Scenario: Connexion réussie pour un utilisateur "ADMIN"
        Given driver baseUrl
            And waitFor('form')
            And input(ui.locator.input('Username or email'), 'cnoir')
            And input(ui.locator.input('Password'), 'a123456')
        When submit().click(ui.locator.button('Log In'))
        Then match html('body') contains 'Sélectionnez un bureau pour parcourir ses dossiers'
            And assert exists(ui.locator.header['i-Parapheur']) == true
            And assert exists(ui.locator.header['Maison']) == true
            And assert exists(ui.locator.header['Archives']) == true
            And assert exists(ui.locator.header['Statistiques']) == true
            And assert exists(ui.locator.header['Administration']) == true
            And assert exists(ui.locator.header['Profil']) == true
            And assert exists(ui.locator.header['Déconnexion']) == true

    @fixme-ip-web @l10n @permissions
        Scenario: Connexion réussie pour un utilisateur "FUNCTIONAL_ADMIN"
        Given driver baseUrl
            And waitFor('form')
            And input(ui.locator.input('Username or email'), 'ablanc')
            And input(ui.locator.input('Password'), 'a123456')
        When submit().click(ui.locator.button('Log In'))
        Then match html('body') contains 'Sélectionnez un bureau pour parcourir ses dossiers'
            And assert exists(ui.locator.header['i-Parapheur']) == true
            And assert exists(ui.locator.header['Maison']) == true
            And assert exists(ui.locator.header['Archives']) == true
            # @fixme-ip-core @fixme-ip-web
            # And assert exists(ui.locator.header['Statistiques']) == false
            And assert exists(ui.locator.header['Administration']) == true
            And assert exists(ui.locator.header['Profil']) == true
            And assert exists(ui.locator.header['Déconnexion']) == true

    @fixme-ip-web @l10n
        Scenario: Connexion réussie pour un utilisateur "NONE"
        Given driver baseUrl
            And waitFor('form')
            And input(ui.locator.input('Username or email'), 'ltransparent')
            And input(ui.locator.input('Password'), 'a123456')
        When submit().click(ui.locator.button('Log In'))
        Then match html('body') contains 'Sélectionnez un bureau pour parcourir ses dossiers'
            And assert exists(ui.locator.header['i-Parapheur']) == true
            And assert exists(ui.locator.header['Maison']) == true
            And assert exists(ui.locator.header['Archives']) == true
            # @fixme-ip-core @fixme-ip-web
            #And assert exists(ui.locator.header['Statistiques']) == false
            #And assert exists(ui.locator.header['Administration']) == false
            And assert exists(ui.locator.header['Profil']) == true
            And assert exists(ui.locator.header['Déconnexion']) == true

    @fixme-ip-web @l10n
        Scenario: Connexion ratée
        Given driver baseUrl
            And waitFor('form')
            And input(ui.locator.input('Username or email'), '')
            And input(ui.locator.input('Password'), '')
        When submit().click(ui.locator.button('Log In'))
        Then match html('body') contains 'Invalid username or password'
