@ip5 @ip-web @l10n
Feature: Connexion

    Background:
        * configure driver = ui.driver.configure
        # force logout between each scenario
        * driver baseUrl + ui.url.logout

    Scenario: Accéder à la page de connexion
        Given driver baseUrl
            And waitFor('form')
        Then match html('body') contains 'Bienvenue sur la page de connexion iparapheur'
            And match html('body') contains 'Veuillez saisir vos identifiants de connexion'
            And match html('body') contains 'Identifiant ou courriel'
            And match html('body') contains 'Mot de passe'
            And match html('body') contains 'Mot de passe oublié ?'
            And match html('body') contains 'Se connecter'

    @permissions
    Scenario: Connexion réussie pour un utilisateur "ADMIN"
        Given driver baseUrl
            And waitFor('form')
            And input(ui.locator.input('Identifiant ou courriel'), 'cnoir')
            And input(ui.locator.input('Mot de passe'), 'a123456')
        When submit().click(ui.locator.button('Se connecter'))
            And waitFor('{^}Bienvenue sur le iparapheur')
        Then match html('body') contains 'Sélectionnez un bureau pour parcourir ses dossiers'
            And assert exists(ui.locator.header['iparapheur']) == true
            And assert exists(ui.locator.header['Maison']) == true
            And assert exists(ui.locator.header['Archives']) == true
            And assert exists(ui.locator.header['Statistiques']) == true
            And assert exists(ui.locator.header['Administration']) == true
            And assert exists(ui.locator.header['Profil']) == true
            And assert exists(ui.locator.header['Déconnexion']) == true

    @permissions
    Scenario: Connexion réussie pour un utilisateur "FUNCTIONAL_ADMIN"
        Given driver baseUrl
            And waitFor('form')
            And input(ui.locator.input('Identifiant ou courriel'), 'ablanc')
            And input(ui.locator.input('Mot de passe'), 'a123456')
        When submit().click(ui.locator.button('Se connecter'))
            And waitFor('{^}Bienvenue sur le iparapheur')
        Then match html('body') contains 'Sélectionnez un bureau pour parcourir ses dossiers'
            And assert exists(ui.locator.header['iparapheur']) == true
            And assert exists(ui.locator.header['Maison']) == true
            And assert exists(ui.locator.header['Archives']) == true
            # @fixme-ip-core @fixme-ip-web
            # And assert exists(ui.locator.header['Statistiques']) == false
            And assert exists(ui.locator.header['Administration']) == true
            And assert exists(ui.locator.header['Profil']) == true
            And assert exists(ui.locator.header['Déconnexion']) == true

    @permissions
    Scenario: Connexion réussie pour un utilisateur "NONE"
        Given driver baseUrl
            And waitFor('form')
            And input(ui.locator.input('Identifiant ou courriel'), 'ltransparent')
            And input(ui.locator.input('Mot de passe'), 'a123456')
        When submit().click(ui.locator.button('Se connecter'))
            And waitFor('{^}Bienvenue sur le iparapheur')
        Then match html('body') contains 'Sélectionnez un bureau pour parcourir ses dossiers'
            And assert exists(ui.locator.header['iparapheur']) == true
            And assert exists(ui.locator.header['Maison']) == true
            And assert exists(ui.locator.header['Archives']) == true
            # @fixme-ip-core @fixme-ip-web
            #And assert exists(ui.locator.header['Statistiques']) == false
            #And assert exists(ui.locator.header['Administration']) == false
            And assert exists(ui.locator.header['Profil']) == true
            And assert exists(ui.locator.header['Déconnexion']) == true

    @permissions
    Scenario: Connexion ratée
        Given driver baseUrl
            And waitFor('form')
            And input(ui.locator.input('Identifiant ou courriel'), '')
            And input(ui.locator.input('Mot de passe'), '')
        When submit().click(ui.locator.button('Se connecter'))
        Then match html('body') contains 'Identifiant ou mot de passe invalide'
