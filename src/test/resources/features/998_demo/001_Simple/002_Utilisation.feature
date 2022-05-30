@ip-web @l10n @demo-bde
Feature: 002 - Scénario de démo simple, partie utilisation

    Background:
        * configure driver = ui.driver.configure
        * driver baseUrl + ui.url.logout

    Scenario Outline: Envoi d'un dossier dans le circuit pour le sous-type ${type}/${subtype}
        * def params =
"""
{
    tenant: '<tenant>',
    desktop: '<desk>',
    type: '<type>',
    subtype: '<subtype>',
    mainFile: '<document>',
    nameTemplate: '<nameTemplate>'
}
"""
        * api_v1.auth.login('user', 'password')
        * def folders = api_v1.desk.draft.getPayloadMonodoc(params, 1, {}, 1)
        * api_v1.auth.login('<username>', '<password>')
        * def result = call read('classpath:lib/api/draft/create-and-send-monodoc-without-annex.feature') folders
        # @fixme: use UI
        #* call read('classpath:lib/ui/desk/create-and-send.feature') __row

      Examples:
          | tenant | username | password | desk       | document                                                | type  | subtype | nameTemplate           |
          | Démo   | ws@demo  | a123456  | WebService | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | ACTES | Visa    | Délibération %counter% |

    Scenario: Visa sur le dossier "Délibération 1" (ACTES/Visa)
        * ui.user.login("flosserand@demo", "a123456")
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * click("{a}Président")
        * waitFor(ui.element.breadcrumb("Accueil / Démo / Président / Dossiers en cours"))
        * click("{a}Délibération 1")
        * waitFor(ui.element.breadcrumb("Accueil / Démo / Président / Délibération 1"))
        * click("//button[contains(normalize-space(text()), 'Visa')]")
        * waitFor("{}Annotation publique").input("Annotation publique FLO")
        * waitFor("{}Annotation privée").input("Annotation privée FLO")
        * click("{^}Valider")
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * waitFor(ui.toast.success("action Visa sur le dossier Délibération 1 a été effectuée avec succès"))
    @wip
    Scenario: Vérifications (annotations, journal des événements) du dossier en fin de circuit "Délibération 1" (ACTES/Visa)
        * ui.user.login("ws@demo", "a123456")
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * click("{a}WebService")
        * waitFor(ui.element.breadcrumb("Accueil / Démo / WebService / Dossiers en cours"))
        * waitFor(".badge-finished").click()
        * waitFor(ui.element.breadcrumb("Accueil / Démo / WebService / Dossiers en fin de circuit"))
        * click("{a}Délibération 1")
        * waitFor(ui.element.breadcrumb("Accueil / Démo / WebService / Délibération 1"))

        # @info: imprimer ne se fait pas avec un téléchargement mais occupe l'onglet actuel

        # Vérification des annotations
        * assert exists("//*[normalize-space(text())='Annotation publique']/ancestor::app-annotation-display//div[normalize-space(text())='Annotation publique FLO']") == true
        * assert exists("//*[normalize-space(text())='Annotation privée']/ancestor::app-annotation-display//div[normalize-space(text())='Annotation privée FLO']") == true

        # Vérification du journal des événements
        * mouse().move("{^button}Actions").go();
        * click("{^button}Actions")
        * waitFor("{^}Journal des évènements").click()
        * def tableBody = "//ngb-modal-window//table//tbody"
        * waitFor(tableBody)
        # Étape de démarrage
        * waitFor(tableBody + "/tr[1]//td[2][normalize-space(text())='WebService']")
        * waitFor(tableBody + "/tr[1]//td[3]/span[normalize-space(text())='Web Service']")
        * waitFor(tableBody + "/tr[1]//td[4][normalize-space(text())='']")
        * waitFor(tableBody + "/tr[1]//td[5][normalize-space(text())='Démarrage']")
        # Étape de visa
        * waitFor(tableBody + "/tr[2]//td[2][normalize-space(text())='Président']")
        * waitFor(tableBody + "/tr[2]//td[3]/span[normalize-space(text())='Frédéric Losserand']")
        * waitFor(tableBody + "/tr[2]//td[4][normalize-space(text())='Annotation publique FLO']")
        * waitFor(tableBody + "/tr[2]//td[5][normalize-space(text())='Visa']")

        * pause(5)
