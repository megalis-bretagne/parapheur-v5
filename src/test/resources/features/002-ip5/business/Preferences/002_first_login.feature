@ip5 @ip-web @l10n @preferences @tests
Feature: 002 - Scénario de test des préférences, première connexion

    Background:
        * configure driver = ip.ui.driver.configure
        * driver baseUrl + ip5.ui.url.logout

    Scenario: Vérification des bureaux à la première connexion
        * ip5.ui.user.login('kpapin', 'a123456')
        # Vérification de la vue tuiles
        * match ip5.ui.desk.getTileNames() == ['Kali_01', 'Kali_02', 'Kali_03', 'Kali_04', 'Kali_05', 'Kali_06', 'Kali_07', 'Kali_08', 'Kali_09', 'Kali_10', 'Kali_11', 'Kali_12', 'Kali_13', 'Kali_14', 'Kali_15']

        # Vérification de la vue liste
        * waitFor("//app-toggle-button//fa-icon").click()
        * ip5.ui.desk.getAllListNames()  == {'Préférences': ['Kali_01', 'Kali_02', 'Kali_03', 'Kali_04', 'Kali_05', 'Kali_06', 'Kali_07', 'Kali_08', 'Kali_09', 'Kali_10', 'Kali_11', 'Kali_12', 'Kali_13', 'Kali_14', 'Kali_15']}
