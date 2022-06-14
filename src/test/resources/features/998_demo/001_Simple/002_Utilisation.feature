@ip-web @l10n @demo-simple-bde
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
        * def folders = api_v1.desk.draft.getPayloadMonodoc(params, <count>, {}, 1)
        * api_v1.auth.login('<username>', '<password>')
        * def result = call read('classpath:lib/api/draft/create-and-send-monodoc-without-annex.feature') folders
        # @fixme: use UI
        #* call read('classpath:lib/ui/desk/create-and-send.feature') __row

      Examples:
          | tenant      | username       | password | desk       | document                                                | type  | subtype | nameTemplate               | count! |
          | Démo simple | ws@demo-simple | a123456  | WebService | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | ACTES | Visa    | Délibération PDF %counter% | 2      |
          | Démo simple | ws@demo-simple | a123456  | WebService | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.odt | ACTES | Visa    | Délibération ODT %counter% | 2      |

    Scenario Outline: ${action} sur le dossier "${name}" (ACTES/Visa)
        * ui.user.login("flosserand@demo-simple", "a123456")
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * click("{a}Président")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / Président / Dossiers en cours"))
        * click("{a}" + name)
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / Président / " + name))
        * click("//button[contains(normalize-space(text()), '" + action + "')]")
        * waitFor("{}Annotation publique").input("Annotation publique FLO")
        * waitFor("{}Annotation privée").input("Annotation privée FLO")
        * click("{^}Valider")
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * waitFor(ui.toast.success("action " + action + " sur le dossier " + name + " a été effectuée avec succès"))

        Examples:
            | name               | action |
            | Délibération PDF 1 | Visa   |
            | Délibération PDF 2 | Rejet  |
            | Délibération ODT 1 | Visa   |
            | Délibération ODT 2 | Rejet  |

    Scenario Outline: Vérifications (annotations, journal des événements) du dossier ${title} "${name}" (ACTES/Visa)
        * ui.user.login("ws@demo-simple", "a123456")
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * click("{a}WebService")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers en cours"))
        * waitFor("<badge>").click()
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers <title>"))
        * click("{a}<name>")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        # @info: imprimer ne se fait pas avec un téléchargement mais occupe l'onglet actuel

        # Vérification des annotations
        # @fixme IP5: en ~ beta40, on a une redite de l'annotation publique lors de la lecture
        #* assert exists("//*[normalize-space(text())='Annotation publique']/ancestor::app-annotation-display//div[normalize-space(text())='Annotation publique FLO']") == true
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
        # @fixme: IP 5
#        * waitFor(tableBody + "/tr[2]//td[5][normalize-space(text())='<action>']")
#        * waitFor(tableBody + "/tr[2]//td[6][normalize-space(text())='<state>']")
        # @todo: étape de fin de circuit

        Examples:
            | badge           | title             | name               | action | state  |
            | .badge-finished | en fin de circuit | Délibération PDF 1 | Visa   |        |
            | .badge-rejected | rejetés           | Délibération PDF 2 | Visa   | Rejeté |
            | .badge-finished | en fin de circuit | Délibération ODT 1 | Visa   |        |
            | .badge-rejected | rejetés           | Délibération ODT 2 | Visa   | Rejeté |
