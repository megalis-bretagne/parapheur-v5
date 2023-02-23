@ip5 @ip-web @l10n @demo-simple-bde @tests
Feature: 002 - Scénario de démo simple, partie utilisation

    Background:
        * configure driver = ip.ui.driver.configure
        * driver baseUrl + ip5.ui.url.logout
        * ip.pause(1)
        * waitFor('#kc-logout').click()

    Scenario Outline: Envoi de ${count} dossier(s) "${nameTemplate}" dans le circuit pour le sous-type ${type} / ${subtype}
        * def params =
        """
        {
            tenant: '<tenant>',
            desktop: '<desk>',
            type: '<type>',
            subtype: '<subtype>',
            mainFile: '<document>',
            nameTemplate: '<nameTemplate>',
            annotation: '<annotation>',
            username: '<username>',
        }
        """
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def folders = ip5.api.v1.desk.draft.getPayloadMonodoc(params, <count>, {}, 1)
        * ip5.api.v1.auth.login('<username>', '<password>')
        * def result = call read('classpath:lib/ip5/api/draft/create-and-send-monodoc-without-annex.feature') folders

        Examples:
            | tenant      | username       | password | desk       | document                                                                | type  | subtype | nameTemplate                          | count! | annotation |
            | Démo simple | ws@demo-simple | a123456  | WebService | classpath:files/formats/document_office/document_office.doc             | ACTES | Visa    | Délibération DOC %counter%            | 2      | démarrage  |
            | Démo simple | ws@demo-simple | a123456  | WebService | classpath:files/formats/document_libre_office/document_libre_office.odt | ACTES | Visa    | Délibération ODT %counter%            | 2      | démarrage  |
            | Démo simple | ws@demo-simple | a123456  | WebService | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf                 | ACTES | Visa    | Délibération PDF %counter%            | 2      | démarrage  |
            | Démo simple | ws@demo-simple | a123456  | WebService | classpath:files/formats/document_rtf/document_rtf.rtf                   | ACTES | Visa    | Délibération RTF %counter%            | 2      | démarrage  |
            | Démo simple | ws@demo-simple | a123456  | WebService | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf                 | ACTES | Visa    | Demande avis complémentaire %counter% | 2      | démarrage  |

    Scenario Outline: ${action} sur le dossier "${name}" (ACTES/Visa)
        * ip5.ui.user.login("flosserand@demo-simple", "a123456")
        #* match ip5.ui.desk.getTileBadges('Président') == { pending: #(pending) }

        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / Président / Dossiers à traiter"))
        * waitFor("{a}" + name).click()

        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / Président / " + name))

        * waitFor("//*[contains(normalize-space(text()), '" + action + "')]/ancestor-or-self::button").click()
        * ip5.ui.folder.annotate.both("flosserand@demo-simple", action, name)

        * waitFor("{^}Valider").click()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / Président / Dossiers à traiter"))
        * waitFor(ip5.ui.toast.success("action " + action + " sur le dossier " + name + " a été effectuée avec succès"))

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
        * ip5.ui.user.login("flosserand@demo-simple", "a123456")
        #* match ip5.ui.desk.getTileBadges('Président') == { pending: #(pending) }

        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / Président / Dossiers à traiter"))
        * waitFor("{a}" + name).click()

        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / Président / " + name))

        * mouse().move("{^button}Actions").go()
        * waitFor("{^button}Actions").click()
        * waitFor("//span[contains(normalize-space(text()),'avis complémentaire')]/ancestor::a[contains(@class, 'dropdown')]").click()
        * ip5.ui.folder.annotate.both("flosserand@demo-simple", "demande d'avis complémentaire", name)
        # @todo: sélection du bureau (ici, il n'y en a qu'un seul, donc pré-sélectionné)
        * waitFor("//span[contains(normalize-space(text()),'avis complémentaire')]/ancestor::button").click()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / Président / Dossiers à traiter"))
        #* waitFor(ip5.ui.toast.success("avis complémentaire a été effectuée avec succès"))
        * ip5.ui.user.logout()

        # 2. Avis complémentaire
        # @todo: vérifier l'annotation privée
        * ip5.ui.user.login("mpiaumier@demo-simple", "a123456")
        #* match ip5.ui.desk.getTileBadges('DGS') == { pending: 1 }

        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / DGS / Dossiers à traiter"))
        * waitFor("{a}" + name).click()

        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / DGS / " + name))

        * waitFor("//*[contains(normalize-space(text()), 'vis complémentaire')]/ancestor-or-self::button").click()
        * ip5.ui.folder.annotate.both("mpiaumier@demo-simple", "avis complémentaire", name)

        * waitFor("{^}Valider").click()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / DGS / Dossiers à traiter"))
        * waitFor(ip5.ui.toast.success("action Avis complémentaire sur le dossier " + name + " a été effectuée avec succès"))
        * ip5.ui.user.logout()

        # 3. Action sur le dossier
        # @todo: vérifier l'annotation privée
        * ip5.ui.user.login("flosserand@demo-simple", "a123456")
        #* match ip5.ui.desk.getTileBadges('Président') == { pending: #(pending) }

        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / Président / Dossiers à traiter"))
        * waitFor("{a}" + name).click()

        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / Président / " + name))

        * waitFor("//*[contains(normalize-space(text()), '" + action + "')]/ancestor-or-self::button").click()
        * ip5.ui.folder.annotate.both("flosserand@demo-simple", action, name)

        * waitFor("{^}Valider").click()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / Président / Dossiers à traiter"))
        * waitFor(ip5.ui.toast.success("action " + action + " sur le dossier " + name + " a été effectuée avec succès"))

        Examples:
            | name                          | action | pending! |
            | Demande avis complémentaire 1 | Visa   | 2        |
            | Demande avis complémentaire 2 | Rejet  | 1        |

    Scenario Outline: Vérifications des annotations du dossier ${title} "${name}" (ACTES/Visa)
        * ip5.ui.user.login("ws@demo-simple", "a123456")
        #* match ip5.ui.desk.getTileBadges('WebService') == { finished: 5, pending: 0, rejected: 5 }

        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers à traiter"))
        * waitFor("<badge>").click()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers <title>"))
        * waitFor("{a}<name>").click()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

            # Vérifications des annotations
            # 1. Annotation(s) publique(s)
        * table expected
            | Utilisateur          | Annotation publique                                                                                       |
            | "Web Service"        | ip.templates.annotations.getPublic("ws@demo-simple", "démarrage", name)                                      |
            | "Frédéric Losserand" | ip.templates.annotations.getPublic("flosserand@demo-simple", (state === "Rejeté" ? "Rejet" : action ), name) |
        * match ip5.ui.folder.getPublicAnnotations() == expected

            # 2. Annotation privée
        * table expected
            | Utilisateur          | Annotation privée                                                                                          |
            | "Frédéric Losserand" | ip.templates.annotations.getPrivate("flosserand@demo-simple", (state === "Rejeté" ? "Rejet" : action ), name) |
        * match ip5.ui.folder.getPrivateAnnotations() == expected

        # On vérifie que l'on soit toujours bien sur la page de visualisation du dossier
        * exists(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

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

    @fixme-ip5
    Scenario Outline: Vérifications des annotations du dossier ${title} "${name}" (ACTES/Visa)
        * ip5.ui.user.login("ws@demo-simple", "a123456")
        #* match ip5.ui.desk.getTileBadges('WebService') == { finished: 5, pending: 0, rejected: 5 }

        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers à traiter"))
        * waitFor("<badge>").click()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers <title>"))
        * waitFor("{a}<name>").click()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

            # Vérifications des annotations
            # 1. Annotation(s) publique(s)
        * table expected
            | Utilisateur          | Annotation publique                                                                                          |
            | "Web Service"        | ip.templates.annotations.getPublic("ws@demo-simple", "démarrage", name)                                      |
            | "Frédéric Losserand" | ip.templates.annotations.getPublic("flosserand@demo-simple", "demande d'avis complémentaire", name)          |
            | "Matthieu Piaumier"  | ip.templates.annotations.getPublic("mpiaumier@demo-simple", "avis complémentaire", name)                     |
            | "Frédéric Losserand" | ip.templates.annotations.getPublic("flosserand@demo-simple", (state === "Rejeté" ? "Rejet" : action ), name) |
        * match ip5.ui.folder.getPublicAnnotations() == expected

            # 2. Annotation privée
        * table expected
            | Utilisateur          | Annotation privée                                                                                             |
            | "Frédéric Losserand" | ip.templates.annotations.getPrivate("flosserand@demo-simple", (state === "Rejeté" ? "Rejet" : action ), name) |
        * match ip5.ui.folder.getPrivateAnnotations() == expected

        # On vérifie que l'on soit toujours bien sur la page de visualisation du dossier
        * exists(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        Examples:
            | badge           | title             | name                          | action | state  |
            | .badge-finished | en fin de circuit | Demande avis complémentaire 1 | Visa   |        |
            | .badge-rejected | rejetés           | Demande avis complémentaire 2 | Visa   | Rejeté |

    @fixme-ip5 @issue-ip @todo-karate
    Scenario Outline: Vérifications du journal des événements du dossier ${title} "${name}" (ACTES/Visa)
        * ip5.ui.user.login("ws@demo-simple", "a123456")
        #* match ip5.ui.desk.getTileBadges('WebService') == { finished: 5, pending: 0, rejected: 5 }

        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers à traiter"))
        * waitFor("<badge>").click()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers <title>"))
        * waitFor("{a}<name>").click()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        # Vérifications du journal des événements
        * mouse().move("{^button}Actions").go()
        * waitFor("{^button}Actions").click()
        * waitFor("{^}Journal des évènements").click()
        * def upcomingAction = "<state>" === "Rejeté" ? "Supprimer" : "Envoyer dans la corbeille"

        * table expected
            | Bureau       | Utilisateur          | Annotation publique                                                                                       | Action                    | État       |
            | "WebService" | "Web Service"        | ip.templates.annotations.getPublic("ws@demo-simple", "démarrage", name)                                      | "Envoyer dans le circuit" | "Validée"  |
            | "Président"  | "Frédéric Losserand" | ""                                                                                                        | "Lecture"                 | "Validée"  |
            | "Président"  | "Frédéric Losserand" | ip.templates.annotations.getPublic("flosserand@demo-simple", (state === "Rejeté" ? "Rejet" : action ), name) | "<action>"                | "<state>"  |
            | "WebService" | "Web Service"        | ""                                                                                                        | "Lecture"                 | "Validée"  |
            | "WebService" | ""                   | ""                                                                                                        | upcomingAction            | "En cours" |

        * match ip5.ui.folder.getEventLog() == expected
        * waitFor("//*[contains(normalize-space(text()),'Fermer')]//ancestor::button").click()

        # On vérifie que l'on soit toujours bien sur la page de visualisation du dossier
        * exists(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

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

    @fixme-ip5 @issue-ip @todo-karate
    Scenario Outline: Vérifications du journal des événements du dossier ${title} "${name}" (ACTES/Visa)
        * ip5.ui.user.login("ws@demo-simple", "a123456")
        #* match ip5.ui.desk.getTileBadges('WebService') == { finished: 5, pending: 0, rejected: 5 }

        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers à traiter"))
        * waitFor("<badge>").click()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers <title>"))
        * waitFor("{a}<name>").click()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        # Vérifications du journal des événements
        * mouse().move("{^button}Actions").go()
        * waitFor("{^button}Actions").click()
        * waitFor("{^}Journal des évènements").click()
        * def upcomingAction = "<state>" === "Rejeté" ? "Supprimer" : "Envoyer dans la corbeille"

        * table expected
            | Bureau       | Utilisateur          | Annotation publique                                                                                       | Action                    | État       |
            | "WebService" | "Web Service"        | ip.templates.annotations.getPublic("ws@demo-simple", "démarrage", name)                                      | "Envoyer dans le circuit" | "Validée"  |
            | "Président"  | "Frédéric Losserand" | ""                                                                                                        | "Lecture"                 | "Validée"  |
            | "Président"  | "Frédéric Losserand" | ip.templates.annotations.getPublic("flosserand@demo-simple", "demande d'avis complémentaire", name)          | "Visa"                    | "Validée"  |
            | "DGS"        | "Matthieu Piaumier"  | ""                                                                                                        | "Lecture"                 | "Validée"  |
            | "DGS"        | "Matthieu Piaumier"  | ip.templates.annotations.getPublic("mpiaumier@demo-simple", "avis complémentaire", name)                     | "Avis complémentaire"     | "Validée"  |
            | "Président"  | "Frédéric Losserand" | ip.templates.annotations.getPublic("flosserand@demo-simple", (state === "Rejeté" ? "Rejet" : action ), name) | "<action>"                | "<state>"  |
            | "WebService" | "Web Service"        | ""                                                                                                        | "Lecture"                 | "Validée"  |
            | "WebService" | ""                   | ""                                                                                                        | upcomingAction            | "En cours" |

        * match ip5.ui.folder.getEventLog() == expected
        * waitFor("//*[contains(normalize-space(text()),'Fermer')]//ancestor::button").click()

        # On vérifie que l'on soit toujours bien sur la page de visualisation du dossier
        * exists(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        Examples:
            | badge           | title             | name                          | action | state  |
            | .badge-finished | en fin de circuit | Demande avis complémentaire 1 | Visa   |        |
            | .badge-rejected | rejetés           | Demande avis complémentaire 2 | Visa   | Rejeté |


    Scenario Outline: Vérifications des impressions (avec le bordereau de signature) du dossier ${title} "${name}" (ACTES/Visa)
        # @info: séparé des vérifications précédentes car sinon, on a une question de Chrome: ... souhaite télécharger plusieurs fichiers. Bloquer|Autoriser
        * ip5.ui.user.login("ws@demo-simple", "a123456")
        #* match ip5.ui.desk.getTileBadges('WebService') == { finished: 5, pending: 0, rejected: 5 }

        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers à traiter"))
        * waitFor("<badge>").click()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers <title>"))
        * waitFor("{a}<name>").click()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        # Vérifications des impressions
        # @todo: il faudrait vérifier que l'on a bien téléchargé des fichiers PDF
        # 1. Avec le borderau de signature (case cochée par défaut)
        * waitFor("//button[@name='secondary_actions_button']").click()
        * waitFor("//a[@name='secondary_actions_menu_link_print']").click()
        * waitFor("//button[@name='perform_action_print']").click()
        * waitFor("{^}Annuler").click()
        * waitForResultCount("//button[@name='perform_action_print']", 0)

        # On vérifie que l'on soit toujours bien sur la page de visualisation du dossier après les actions d'impression
        * exists(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

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
        * ip5.ui.user.login("ws@demo-simple", "a123456")
        #* match ip5.ui.desk.getTileBadges('WebService') == { finished: 5, pending: 0, rejected: 5 }

        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers à traiter"))
        * waitFor("<badge>").click()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / Dossiers <title>"))
        * waitFor("{a}<name>").click()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))

        # 2. Sans le bordereau de signature (case cochée par défaut)
        # @todo: il faudrait vérifier que l'on a bien téléchargé des fichiers PDF
        * waitFor("//button[@name='secondary_actions_button']").click()
        * waitFor("//a[@name='secondary_actions_menu_link_print']").click()
        * waitFor("{^}Imprimer le bordereau de signature").click()
        * waitFor("//button[@name='perform_action_print']").click()
        * waitFor("{^}Annuler").click()
        * waitForResultCount("//button[@name='perform_action_print']", 0)

        # On vérifie que l'on soit toujours bien sur la page de visualisation du dossier après les actions d'impression
        * exists(ip5.ui.element.breadcrumb("Accueil / Démo simple / WebService / <name>"))
        * ip.pause(1)

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
