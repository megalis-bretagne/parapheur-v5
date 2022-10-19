@ip5 @ip-web @l10n @preferences @tests
Feature: 003 - Tableau de bord, vérification des colonnes

    Background:
        * configure driver = ip.ui.driver.configure
        * driver baseUrl + ip5.ui.url.logout

        * ip5.ui.user.login('kpapin', 'a123456')
        * mouse().move("//app-header//div[contains(concat(' ', @class, ' '), ' header-menu ')]")
        * click("{*}Profil")
        * click("{*}Tableau de bord")

    Scenario: Vérification des colonnes disponibles et affichées
        * ip5.ui.columns.getDashboardColumnsByType("Colonnes Disponible", 1) == ['ID de la tâche', 'ID du dossier']
        * ip5.ui.columns.getDashboardColumnsByType("Colonnes affichées", 2) == ['Nom', 'État', 'Type', 'Sous-type', 'Bureau courant', 'Date limite', 'Création', 'Émetteur']

#    @wip
#    Scenario: XXX
#        * ip5.ui.columns.getDashboardColumnsByType("Colonnes Disponible", 1) == ['ID de la tâche', 'ID du dossier']
#        * ip5.ui.columns.getDashboardColumnsByType("Colonnes affichées", 2) == ['Nom', 'État', 'Type', 'Sous-type', 'Bureau courant', 'Date limite', 'Création', 'Émetteur']
