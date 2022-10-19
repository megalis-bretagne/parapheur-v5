@ip5 @ip-web @l10n @preferences @tests
Feature: 003 - Tableau de bord, vérification des colonnes

    Background:
        * configure driver = ip.ui.driver.configure
        * driver baseUrl + ip5.ui.url.logout
        * def navigateToDashboard =
"""
function(desk) {
    click("//*[contains(concat(' ', @class, ' '), ' fa-home ')]/parent::fa-icon");
    click("{a}" + desk);
}
"""
        * def navigateToDashboardPreferences =
"""
function() {
    mouse().move("//app-header//div[contains(concat(' ', @class, ' '), ' header-menu ')]");
    click("{*}Profil");
    click("{*}Tableau de bord");
    waitFor("{^}Modification du tableau de bord");
}
"""

    Scenario: Vérification des colonnes affichées dans le tableau de bord du bureau Kali_01
        * ip5.ui.user.login('kpapin', 'a123456')

        * navigateToDashboard("Kali_01")
        * ip5.ui.desk.getColumns() == ['Nom', 'État', 'Type', 'Sous-type', 'Bureau courant', 'Date limite', 'Création', 'Émetteur']

    Scenario: Vérification des colonnes disponibles et affichées dans les préférences
        * ip5.ui.user.login('kpapin', 'a123456')
        * navigateToDashboardPreferences()

        * ip5.ui.columns.getDashboardPreferencesColumnsByType("Colonnes Disponible", 1) == ['ID de la tâche', 'ID du dossier']
        * ip5.ui.columns.getDashboardPreferencesColumnsByType("Colonnes affichées", 2) == ['Nom', 'État', 'Type', 'Sous-type', 'Bureau courant', 'Date limite', 'Création', 'Émetteur']

    @wip
    Scenario: Paramétrages de l'affichage dans les préférences et vérifications dans le tableau de bord du bureau Kali_01
        * ip5.ui.user.login('kpapin', 'a123456')

        # @fixme: drag and drop
#        # "//span[contains(normalize-space(.), 'Sous-type')]/ancestor::div[contains(concat(' ', @class, ' '), ' cdk-drag ')]//*[contains(concat(' ', @class, ' '), ' cdk-drag-handle ')]"
#        # @todo https://stackoverflow.com/a/60800181
#        * navigateToDashboardPreferences()
#        * ip.pause(5)
#
#        * def elmtLocator = "//span[contains(normalize-space(.), 'Sous-type')]/ancestor::div[contains(concat(' ', @class, ' '), ' cdk-drag ')]//*[contains(concat(' ', @class, ' '), ' cdk-drag-handle ')]"
#        * def elmtLocatorPosition = position("//span[contains(normalize-space(.), 'Nom')]")
#        * waitFor(elmtLocator).mouse().down().move(elmtLocatorPosition.x, elmtLocatorPosition.y).go().up()
#
##        * script("var myDragEvent = new Event('dragstart'); myDragEvent.dataTransfer = new DataTransfer()")
##        * waitFor("//span[contains(normalize-space(.), 'Sous-type')]/ancestor::div[contains(concat(' ', @class, ' '), ' cdk-drag ')]//*[contains(concat(' ', @class, ' '), ' cdk-drag-handle ')]").script("_.dispatchEvent(myDragEvent)")
##        * script("var myDropEvent = new Event('drop'); myDropEvent.dataTransfer = myDragEvent.dataTransfer")
##        * ip.pause(5)
##        * screenshot()
###        * def posDropZone = position("//span[contains(normalize-space(.), 'Nom')]")
###        * karate.log(posDropZone)
###        * karate.log(mouse().move(posDropZone.x, posDropZone.y))
###        * karate.log(mouse())
###        * mouse().move(posDropZone.x, posDropZone.y).go().script("_.dispatchEvent(myDropEvent)")
###        * script("//*[contains(concat(' ', @class, ' '), ' cdk-drop-list ')]", "_.dispatchEvent(myDropEvent)")
##        #* script("//span[contains(normalize-space(.), 'Nom')]", "_.dispatchEvent(myDropEvent)")
###        * waitFor("//span[contains(normalize-space(.), 'Nom')]").script("_.dispatchEvent(myDropEvent)")
##
##        * def posDropZone = position("//span[contains(normalize-space(.), 'Nom')]")
##        * karate.log(posDropZone)
##        * mouse().move(posDropZone.x, posDropZone.y).go()
##        * script("//span[contains(normalize-space(.), 'Nom')]", "_.dispatchEvent(myDropEvent)")
#        * ip.pause(5)
#        * screenshot()

        #------------------------------------------------------------------------------------------

        # Ajout d'une colonne dans les préférences
        * navigateToDashboardPreferences()
        * click("//span[contains(normalize-space(.), 'ID de la ')]/parent::div//fa-icon")
        # Vérification dans les préférences
        * ip5.ui.columns.getDashboardPreferencesColumnsByType("Colonnes Disponible", 1) == ['ID du dossier']
        * ip5.ui.columns.getDashboardPreferencesColumnsByType("Colonnes affichées", 2) == ['Nom', 'État', 'Type', 'Sous-type', 'Bureau courant', 'Date limite', 'Création', 'Émetteur', 'ID de la tâche']
        # Vérification sur le bureau
        * navigateToDashboard("Kali_01")
        * ip5.ui.desk.getColumns() == ['Nom', 'État', 'Type', 'Sous-type', 'Bureau courant', 'Date limite', 'Création', 'Émetteur', 'ID de la tâche']

        # Suppression d'une colonne dans les préférences
        * navigateToDashboardPreferences()
        * click("//span[contains(normalize-space(.), 'ID de la ')]/parent::div//fa-icon")
        # Vérification dans les préférences
        * ip5.ui.columns.getDashboardPreferencesColumnsByType("Colonnes Disponible", 1) == ['ID du dossier', 'ID de la tâche']
        * ip5.ui.columns.getDashboardPreferencesColumnsByType("Colonnes affichées", 2) == ['Nom', 'État', 'Type', 'Sous-type', 'Bureau courant', 'Date limite', 'Création', 'Émetteur']
        # Vérification dans les préférences
        * navigateToDashboard("Kali_01")
        * ip5.ui.desk.getColumns() == ['Nom', 'État', 'Type', 'Sous-type', 'Bureau courant', 'Date limite', 'Création', 'Émetteur']
