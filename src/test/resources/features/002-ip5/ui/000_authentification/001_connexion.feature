@ip5 @ip-web @l10n
Feature: Connexion

    Background:
        # * configure driver = ip.ui.driver.configure
        # force logout between each scenario
        * driver baseUrl + ip5.ui.url.logout

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
            And input(ip5.ui.locator.input('Identifiant ou courriel'), 'cnoir')
            And input(ip5.ui.locator.input('Mot de passe'), 'a123456a123456')
        When submit().click(ip5.ui.locator.button('Se connecter'))
            And waitFor('{^}Bienvenue sur le iparapheur')
        Then match html('body') contains 'Sélectionnez un bureau pour parcourir ses dossiers'
            And assert exists(ip5.ui.locator.header['iparapheur']) == true
            And assert exists(ip5.ui.locator.header['Maison']) == true
            And assert exists(ip5.ui.locator.header['Archives']) == true
            And assert exists(ip5.ui.locator.header['Statistiques']) == true
            And assert exists(ip5.ui.locator.header['Administration']) == true
            And assert exists(ip5.ui.locator.header['Profil']) == true
            And assert exists(ip5.ui.locator.header['Déconnexion']) == true

    @permissions
    Scenario: Connexion réussie pour un utilisateur "FUNCTIONAL_ADMIN"
        Given driver baseUrl
            And waitFor('form')
            And input(ip5.ui.locator.input('Identifiant ou courriel'), 'ablanc')
            And input(ip5.ui.locator.input('Mot de passe'), 'a123456a123456')
        When submit().click(ip5.ui.locator.button('Se connecter'))
            And waitFor('{^}Bienvenue sur le iparapheur')
        Then match html('body') contains 'Sélectionnez un bureau pour parcourir ses dossiers'
            And assert exists(ip5.ui.locator.header['iparapheur']) == true
            And assert exists(ip5.ui.locator.header['Maison']) == true
            And assert exists(ip5.ui.locator.header['Archives']) == true
            # @fixme-ip5 @fixme-ip5
            # And assert exists(ip5.ui.locator.header['Statistiques']) == false
            And assert exists(ip5.ui.locator.header['Administration']) == true
            And assert exists(ip5.ui.locator.header['Profil']) == true
            And assert exists(ip5.ui.locator.header['Déconnexion']) == true

    @permissions
    Scenario: Connexion réussie pour un utilisateur "NONE"
        Given driver baseUrl
            And waitFor('form')
            And input(ip5.ui.locator.input('Identifiant ou courriel'), 'ltransparent')
            And input(ip5.ui.locator.input('Mot de passe'), 'a123456a123456')
        When submit().click(ip5.ui.locator.button('Se connecter'))
            And waitFor('{^}Bienvenue sur le iparapheur')
        Then match html('body') contains 'Sélectionnez un bureau pour parcourir ses dossiers'
            And assert exists(ip5.ui.locator.header['iparapheur']) == true
            And assert exists(ip5.ui.locator.header['Maison']) == true
            And assert exists(ip5.ui.locator.header['Archives']) == true
            # @fixme-ip5 @fixme-ip5
            #And assert exists(ip5.ui.locator.header['Statistiques']) == false
            #And assert exists(ip5.ui.locator.header['Administration']) == false
            And assert exists(ip5.ui.locator.header['Profil']) == true
            And assert exists(ip5.ui.locator.header['Déconnexion']) == true

    @permissions
    Scenario: Connexion ratée
        Given driver baseUrl
            And waitFor('form')
            And input(ip5.ui.locator.input('Identifiant ou courriel'), '')
            And input(ip5.ui.locator.input('Mot de passe'), '')
        When submit().click(ip5.ui.locator.button('Se connecter'))
        Then match html('body') contains 'Identifiant ou mot de passe invalide'
