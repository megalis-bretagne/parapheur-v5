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

    Scenario Outline: Vérifications (annotations, journal des événements, impressions) du dossier ${title} "${name}" (ACTES/Visa)
        * ui.user.login("ws@demo-simple", "a123456")
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * click("{a}WebService")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers en cours"))
        * waitFor("<badge>").click()
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers <title>"))
        * click("{a}<name>")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        # Vérifications des annotations
        # 1. Annotation(s) publique(s)
        * table expected
            | Utilisateur          | Annotation publique       |
            | 'Frédéric Losserand' | 'Annotation publique FLO' |
        * def actual = ui.folder.getPublicAnnotations()
        * match actual == expected

        # 2. Annotation privée
        * table expected
            | Utilisateur          | Annotation privée       |
            | 'Frédéric Losserand' | 'Annotation privée FLO' |
        * def actual = ui.folder.getPrivateAnnotations()
        * match actual == expected

        # Vérifications du journal des événements
        * mouse().move("{^button}Actions").go();
        * click("{^button}Actions")
        * waitFor("{^}Journal des évènements").click()

        * table expected
            | Bureau       | Utilisateur          | Annotation publique       | Action      | État      |
            | 'WebService' | 'Web Service'        | ''                        | 'Démarrage' | ''        |
            | 'Président'  | 'Frédéric Losserand' | ''                        | 'Lecture'   | ''        |
            | 'Président'  | 'Frédéric Losserand' | 'Annotation publique FLO' | '<action>'  | '<state>' |

        * def actual = ui.folder.getEventLog()
        * match actual == expected
        * click("{^button}Fermer")

        # Vérifications des impressions
        # @todo: il faudrait vérifier que l'on a bien téléchargé des fichiers PDF
        # 1. Avec le borderau de signature (cochée par défaut)
        * mouse().move("{^button}Actions").go();
        * click("{^button}Actions")
        * waitFor("{^}Imprimer").click()
        * waitFor("//button[contains(normalize-space(.),'Imprimer')]").click()
        * waitFor("{^}Annuler").click()
        * waitForResultCount("//button[contains(normalize-space(.),'Imprimer')]", 0);
        # 2. Sans le borderau de signature (cochée par défaut)
        # @fixme: on a une question de Chrome: ... souhaite télécharger plusieurs fichiers. Bloquer|Autoriser
#        * mouse().move("{^button}Actions").go();
#        * click("{^button}Actions")
#        * waitFor("{^}Imprimer").click()
#        * waitFor("{^}Imprimer le bordereau de signature").click()
#        * waitFor("//button[contains(normalize-space(.),'Imprimer')]").click()
#        * waitFor("{^}Annuler").click()
#        * waitForResultCount("//button[contains(normalize-space(.),'Imprimer')]", 0);

        # On vérifie que l'on soit toujours bien sur la page de visualisation du dossier après les actions d'impression
        * exists(ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        Examples:
            | badge           | title             | name               | action | state  |
            | .badge-finished | en fin de circuit | Délibération PDF 1 | Visa   |        |
            | .badge-rejected | rejetés           | Délibération PDF 2 | Visa   | Rejeté |
            | .badge-finished | en fin de circuit | Délibération ODT 1 | Visa   |        |
            | .badge-rejected | rejetés           | Délibération ODT 2 | Visa   | Rejeté |
