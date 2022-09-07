@ip-web @l10n @demo-simple-bde @tests
Feature: 002 - Scénario de démo simple, partie utilisation

    Background:
        * configure driver = ui.driver.configure
        * driver baseUrl + ui.url.logout

    Scenario Outline: Envoi de ${count} dossier(s) "${nameTemplate}" dans le circuit pour le sous-type ${type}/${subtype}
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
            | tenant      | username       | password | desk       | document                                                                | type  | subtype | nameTemplate                          | count! |
            | Démo simple | ws@demo-simple | a123456  | WebService | classpath:files/formats/document_office/document_office.doc             | ACTES | Visa    | Délibération DOC %counter%            | 2      |
            | Démo simple | ws@demo-simple | a123456  | WebService | classpath:files/formats/document_libre_office/document_libre_office.odt | ACTES | Visa    | Délibération ODT %counter%            | 2      |
            | Démo simple | ws@demo-simple | a123456  | WebService | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf                 | ACTES | Visa    | Délibération PDF %counter%            | 2      |
            | Démo simple | ws@demo-simple | a123456  | WebService | classpath:files/formats/document_rtf/document_rtf.rtf                   | ACTES | Visa    | Délibération RTF %counter%            | 2      |
            | Démo simple | ws@demo-simple | a123456  | WebService | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf                 | ACTES | Visa    | Demande avis complémentaire %counter% | 2      |

    Scenario Outline: ${action} sur le dossier "${name}" (ACTES/Visa)
        # @todo: vérifier le "contenu" du PDF ?
        # $x("//div[@id='viewerContainer']//div[contains(concat(' ', @class,  ' '), ' textLayer ')]//*[contains(., 'Convention bipartite')]")
        * ui.user.login("flosserand@demo-simple", "a123456")
        * match ui.desk.getTileBadges('Président') == { pending: #(pending) }

        * click("{a}Président")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / Président / Dossiers à traiter"))
        * click("{a}" + name)

        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / Président / " + name))
        #* waitFor("//div[@id='viewe#rContainer']//div[contains(concat(' ', @class,  ' '), ' textLayer ')]//*[contains(., 'Convention bipartite')]")

        * click("//*[contains(normalize-space(text()), '" + action + "')]/ancestor-or-self::button")
        * waitFor("{}Annotation publique").input("Annotation publique FLO (" + action + ")")
        * driver.screenshot()
        * waitFor("{}Annotation privée").input("Annotation privée FLO (" + action + ")")
        * driver.screenshot()
        * click("{^}Valider")
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * waitFor(ui.toast.success("action " + action + " sur le dossier " + name + " a été effectuée avec succès"))

        Examples:
            | name               | action | pending! |
            | Délibération DOC 1 | Visa   | 10       |
            | Délibération DOC 2 | Rejet  | 9        |
            | Délibération ODT 1 | Visa   | 8        |
            | Délibération ODT 2 | Rejet  | 7        |
            | Délibération PDF 1 | Visa   | 6        |
            | Délibération PDF 2 | Rejet  | 5        |
            | Délibération RTF 1 | Visa   | 4        |
            | Délibération RTF 2 | Rejet  | 3        |

    Scenario Outline: Demande d'avis complémentaire et ${action} sur le dossier "${name}" (ACTES/Visa)
        # 1. Demande d'avis complémentaire
        * ui.user.login("flosserand@demo-simple", "a123456")
        * match ui.desk.getTileBadges('Président') == { pending: #(pending) }

        * click("{a}Président")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / Président / Dossiers à traiter"))
        * click("{a}" + name)

        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / Président / " + name))

        * mouse().move("{^button}Actions").go()
        * click("{^button}Actions")
        * waitFor("//span[contains(normalize-space(text()),'avis complémentaire')]/ancestor::a[contains(@class, 'dropdown')]").click()
        * waitFor("{}Annotation publique").input("Annotation publique FLO (Demande d'avis complémentaire)")
        * driver.screenshot()
        * waitFor("{}Annotation privée").input("Annotation privée FLO (Demande d'avis complémentaire)")
        * driver.screenshot()
        # @todo: sélection du bureau (ici, il n'y en a qu'un seul, donc pré-sélectionné)
        * click("//span[contains(normalize-space(text()),'avis complémentaire')]/ancestor::button")
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        #* waitFor(ui.toast.success("avis complémentaire a été effectuée avec succès"))
        * ui.user.logout()

        # 2. Avis complémentaire
        # @todo: vérifier l'annotation privée
        * ui.user.login("mpiaumier@demo-simple", "a123456")
        * match ui.desk.getTileBadges('DGS') == { pending: 1 }

        * click("{a}DGS")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / DGS / Dossiers à traiter"))
        * click("{a}" + name)

        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / DGS / " + name))

        * click("//button[contains(normalize-space(text()), 'vis complémentaire')]")
        * waitFor("{}Annotation publique").input("Annotation publique MPI (Avis complémentaire)")
        * driver.screenshot()
        * waitFor("{}Annotation privée").input("Annotation privée MPI (Avis complémentaire)")
        * driver.screenshot()
        * click("{^}Valider")
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * waitFor(ui.toast.success("action Avis complémentaire sur le dossier " + name + " a été effectuée avec succès"))
        * ui.user.logout()

        # 3. Action sur le dossier
        # @todo: vérifier l'annotation privée
        * ui.user.login("flosserand@demo-simple", "a123456")
        * match ui.desk.getTileBadges('Président') == { pending: #(pending) }

        * click("{a}Président")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / Président / Dossiers à traiter"))
        * click("{a}" + name)

        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / Président / " + name))

        * click("//button[contains(normalize-space(text()), '" + action + "')]")
        * waitFor("#publicAnnotation").input("Annotation publique FLO (" + action + ")")
        * driver.screenshot()
        * waitFor("#privateAnnotation").input("Annotation privée FLO (" + action + ")")
        * driver.screenshot()
        * click("{^}Valider")
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * waitFor(ui.toast.success("action " + action + " sur le dossier " + name + " a été effectuée avec succès"))

        Examples:
            | name                          | action | pending! |
            | Demande avis complémentaire 1 | Visa   | 2        |
            | Demande avis complémentaire 2 | Rejet  | 1        |

    Scenario Outline: Vérifications des annotations du dossier ${title} "${name}" (ACTES/Visa)
        * ui.user.login("ws@demo-simple", "a123456")
        * match ui.desk.getTileBadges('WebService') == { finished: 5, pending: 0, rejected: 5 }

        * click("{a}WebService")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers à traiter"))
        * waitFor("<badge>").click()
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers <title>"))
        * click("{a}<name>")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

            # Vérifications des annotations
            # 1. Annotation(s) publique(s)
        * table expected
            | Utilisateur          | Annotation publique                                                          |
            | 'Frédéric Losserand' | 'Annotation publique FLO (' + (state === 'Rejeté' ? 'Rejet' : action ) + ')' |
        * match ui.folder.getPublicAnnotations() == expected

            # 2. Annotation privée
        * table expected
            | Utilisateur          | Annotation privée                                                          |
            | 'Frédéric Losserand' | 'Annotation privée FLO (' + (state === 'Rejeté' ? 'Rejet' : action ) + ')' |
        * match ui.folder.getPrivateAnnotations() == expected

        # On vérifie que l'on soit toujours bien sur la page de visualisation du dossier
        * exists(ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        Examples:
            | badge           | title             | name               | action | state  |
            | .badge-finished | en fin de circuit | Délibération DOC 1 | Visa   |        |
            | .badge-rejected | rejetés           | Délibération DOC 2 | Visa   | Rejeté |
            | .badge-finished | en fin de circuit | Délibération ODT 1 | Visa   |        |
            | .badge-rejected | rejetés           | Délibération ODT 2 | Visa   | Rejeté |
            | .badge-finished | en fin de circuit | Délibération PDF 1 | Visa   |        |
            | .badge-rejected | rejetés           | Délibération PDF 2 | Visa   | Rejeté |
            | .badge-finished | en fin de circuit | Délibération RTF 1 | Visa   |        |
            | .badge-rejected | rejetés           | Délibération RTF 2 | Visa   | Rejeté |

    @fixme-ip
    Scenario Outline: Vérifications des annotations du dossier ${title} "${name}" (ACTES/Visa)
        * ui.user.login("ws@demo-simple", "a123456")
        * match ui.desk.getTileBadges('WebService') == { finished: 5, pending: 0, rejected: 5 }

        * click("{a}WebService")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers à traiter"))
        * waitFor("<badge>").click()
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers <title>"))
        * click("{a}<name>")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

            # Vérifications des annotations
            # 1. Annotation(s) publique(s)
        * table expected
            | Utilisateur          | Annotation publique                                                          |
            | 'Frédéric Losserand' | 'Annotation publique FLO (Demande d\'avis complémentaire)'                   |
            | 'Frédéric Losserand' | 'Annotation publique MPI (Avis complémentaire)'                              |
            | 'Frédéric Losserand' | 'Annotation publique FLO (' + (state === 'Rejeté' ? 'Rejet' : action ) + ')' |
        * match ui.folder.getPublicAnnotations() == expected

            # 2. Annotation privée
        * table expected
            | Utilisateur          | Annotation privée                                                          |
            | 'Frédéric Losserand' | 'Annotation privée FLO (' + (state === 'Rejeté' ? 'Rejet' : action ) + ')' |
        * match ui.folder.getPrivateAnnotations() == expected

        # On vérifie que l'on soit toujours bien sur la page de visualisation du dossier
        * exists(ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        Examples:
            | badge           | title             | name                          | action | state  |
            | .badge-finished | en fin de circuit | Demande avis complémentaire 1 | Visa   |        |
            | .badge-rejected | rejetés           | Demande avis complémentaire 2 | Visa   | Rejeté |

    @fixme-ip @issue-ip @todo-karate
    Scenario Outline: Vérifications du journal des événements du dossier ${title} "${name}" (ACTES/Visa)
        * ui.user.login("ws@demo-simple", "a123456")
        * match ui.desk.getTileBadges('WebService') == { finished: 5, pending: 0, rejected: 5 }

        * click("{a}WebService")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers à traiter"))
        * waitFor("<badge>").click()
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers <title>"))
        * click("{a}<name>")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        # Vérifications du journal des événements
        * mouse().move("{^button}Actions").go()
        * click("{^button}Actions")
        * waitFor("{^}Journal des évènements").click()
        * def upcomingAction = "<state>" === "Rejeté" ? "Supprimer" : "Envoyer dans la corbeille"

        * table expected
            | Bureau       | Utilisateur          | Annotation publique                                                          | Action                    | État       |
            | 'WebService' | 'Web Service'        | ''                                                                           | 'Envoyer dans le circuit' | ''         |
            | 'Président'  | 'Frédéric Losserand' | ''                                                                           | 'Lecture'                 | ''         |
            | 'Président'  | 'Frédéric Losserand' | 'Annotation publique FLO (' + (state === 'Rejeté' ? 'Rejet' : action ) + ')' | '<action>'                | '<state>'  |
            | 'WebService' | 'Web Service'        | ''                                                                           | 'Lecture'                 | ''         |
            | 'WebService' | ''                   | ''                                                                           | upcomingAction            | 'En cours' |

        * match ui.folder.getEventLog() == expected
        * click("//*[contains(normalize-space(text()),'Fermer')]//ancestor::button")

        # On vérifie que l'on soit toujours bien sur la page de visualisation du dossier
        * exists(ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        Examples:
            | badge           | title             | name               | action | state  |
            | .badge-finished | en fin de circuit | Délibération DOC 1 | Visa   |        |
            | .badge-rejected | rejetés           | Délibération DOC 2 | Visa   | Rejeté |
            | .badge-finished | en fin de circuit | Délibération ODT 1 | Visa   |        |
            | .badge-rejected | rejetés           | Délibération ODT 2 | Visa   | Rejeté |
            | .badge-finished | en fin de circuit | Délibération PDF 1 | Visa   |        |
            | .badge-rejected | rejetés           | Délibération PDF 2 | Visa   | Rejeté |
            | .badge-finished | en fin de circuit | Délibération RTF 1 | Visa   |        |
            | .badge-rejected | rejetés           | Délibération RTF 2 | Visa   | Rejeté |

    @fixme-ip @issue-ip @todo-karate
    Scenario Outline: Vérifications du journal des événements du dossier ${title} "${name}" (ACTES/Visa)
        * ui.user.login("ws@demo-simple", "a123456")
        * match ui.desk.getTileBadges('WebService') == { finished: 5, pending: 0, rejected: 5 }

        * click("{a}WebService")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers à traiter"))
        * waitFor("<badge>").click()
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers <title>"))
        * click("{a}<name>")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        # Vérifications du journal des événements
        * mouse().move("{^button}Actions").go()
        * click("{^button}Actions")
        * waitFor("{^}Journal des évènements").click()
        * def upcomingAction = "<state>" === "Rejeté" ? "Supprimer" : "Envoyer dans la corbeille"

        * table expected
            | Bureau       | Utilisateur          | Annotation publique                                                          | Action                    | État       |
            | 'WebService' | 'Web Service'        | ''                                                                           | 'Envoyer dans le circuit' | ''         |
            | 'Président'  | 'Frédéric Losserand' | ''                                                                           | 'Lecture'                 | ''         |
            | 'Président'  | 'Frédéric Losserand' | 'Annotation publique FLO (Demande d\'avis complémentaire)'                   | 'Visa'                    | ''         |
            | 'DGS'        | 'Matthieu Piaumier'  | ''                                                                           | 'Lecture'                 | ''         |
            | 'DGS'        | 'Matthieu Piaumier'  | 'Annotation publique MPI (Avis complémentaire)'                              | 'Avis complémentaire'     | ''         |
            | 'Président'  | 'Frédéric Losserand' | 'Annotation publique FLO (' + (state === 'Rejeté' ? 'Rejet' : action ) + ')' | '<action>'                | '<state>'  |
            | 'WebService' | 'Web Service'        | ''                                                                           | 'Lecture'                 | ''         |
            | 'WebService' | ''                   | ''                                                                           | upcomingAction            | 'En cours' |

        * match ui.folder.getEventLog() == expected
        * click("//*[contains(normalize-space(text()),'Fermer')]//ancestor::button")

        # On vérifie que l'on soit toujours bien sur la page de visualisation du dossier
        * exists(ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        Examples:
            | badge           | title             | name                          | action | state  |
            | .badge-finished | en fin de circuit | Demande avis complémentaire 1 | Visa   |        |
            | .badge-rejected | rejetés           | Demande avis complémentaire 2 | Visa   | Rejeté |

    Scenario Outline: Vérifications des impressions (avec le bordereau de signature) du dossier ${title} "${name}" (ACTES/Visa)
        # @info: séparé des vérifications précédentes car sinon, on a une question de Chrome: ... souhaite télécharger plusieurs fichiers. Bloquer|Autoriser
        * ui.user.login("ws@demo-simple", "a123456")
        * match ui.desk.getTileBadges('WebService') == { finished: 5, pending: 0, rejected: 5 }

        * click("{a}WebService")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers à traiter"))
        * waitFor("<badge>").click()
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers <title>"))
        * click("{a}<name>")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        # Vérifications des impressions
        # @todo: il faudrait vérifier que l'on a bien téléchargé des fichiers PDF
        # 1. Avec le borderau de signature (case cochée par défaut)
        * mouse().move("{^button}Actions").go()
        * click("{^button}Actions")
        * waitFor("{^}Imprimer").click()
        * waitFor("//button[contains(normalize-space(.),'Imprimer')]").click()
        * waitFor("{^}Annuler").click()
        * waitForResultCount("//button[contains(normalize-space(.),'Imprimer')]", 0)

        # On vérifie que l'on soit toujours bien sur la page de visualisation du dossier après les actions d'impression
        * exists(ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        Examples:
            | badge           | title             | name                          | action | state  |
            | .badge-finished | en fin de circuit | Délibération DOC 1            | Visa   |        |
            | .badge-rejected | rejetés           | Délibération DOC 2            | Visa   | Rejeté |
            | .badge-finished | en fin de circuit | Délibération ODT 1            | Visa   |        |
            | .badge-rejected | rejetés           | Délibération ODT 2            | Visa   | Rejeté |
            | .badge-finished | en fin de circuit | Délibération PDF 1            | Visa   |        |
            | .badge-rejected | rejetés           | Délibération PDF 2            | Visa   | Rejeté |
            | .badge-finished | en fin de circuit | Délibération RTF 1            | Visa   |        |
            | .badge-rejected | rejetés           | Délibération RTF 2            | Visa   | Rejeté |
            | .badge-finished | en fin de circuit | Demande avis complémentaire 1 | Visa   |        |
            | .badge-rejected | rejetés           | Demande avis complémentaire 2 | Visa   | Rejeté |

    Scenario Outline: Vérifications des impressions (sans le bordereau de signature) du dossier ${title} "${name}" (ACTES/Visa)
        # @info: séparé des vérifications précédentes car sinon, on a une question de Chrome: ... souhaite télécharger plusieurs fichiers. Bloquer|Autoriser
        * ui.user.login("ws@demo-simple", "a123456")
        * match ui.desk.getTileBadges('WebService') == { finished: 5, pending: 0, rejected: 5 }

        * click("{a}WebService")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers à traiter"))
        * waitFor("<badge>").click()
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers <title>"))
        * click("{a}<name>")
        * waitFor(ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        # 2. Sans le bordereau de signature (case cochée par défaut)
        # @todo: il faudrait vérifier que l'on a bien téléchargé des fichiers PDF
        * mouse().move("{^button}Actions").go()
        * click("{^button}Actions")
        * waitFor("{^}Imprimer").click()
        * waitFor("{^}Imprimer le bordereau de signature").click()
        * waitFor("//button[contains(normalize-space(.),'Imprimer')]").click()
        * waitFor("{^}Annuler").click()
        * waitForResultCount("//button[contains(normalize-space(.),'Imprimer')]", 0)

        # On vérifie que l'on soit toujours bien sur la page de visualisation du dossier après les actions d'impression
        * exists(ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))
        * pause(15)

        Examples:
            | badge           | title             | name                          | action | state  |
            | .badge-finished | en fin de circuit | Délibération DOC 1            | Visa   |        |
            | .badge-rejected | rejetés           | Délibération DOC 2            | Visa   | Rejeté |
            | .badge-finished | en fin de circuit | Délibération ODT 1            | Visa   |        |
            | .badge-rejected | rejetés           | Délibération ODT 2            | Visa   | Rejeté |
            | .badge-finished | en fin de circuit | Délibération PDF 1            | Visa   |        |
            | .badge-rejected | rejetés           | Délibération PDF 2            | Visa   | Rejeté |
            | .badge-finished | en fin de circuit | Délibération RTF 1            | Visa   |        |
            | .badge-rejected | rejetés           | Délibération RTF 2            | Visa   | Rejeté |
            | .badge-finished | en fin de circuit | Demande avis complémentaire 1 | Visa   |        |
            | .badge-rejected | rejetés           | Demande avis complémentaire 2 | Visa   | Rejeté |
