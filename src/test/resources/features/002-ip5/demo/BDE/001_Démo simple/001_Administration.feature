@ip5 @ip-web @l10n @demo-simple-bde @setup
Feature: 001 - Scénario de démo simple, partie administration

    Background:
        * configure driver = ip.ui.driver.configure
        * driver baseUrl + ip5.ui.url.logout

    Scenario: Connexion avec un superadmin
        * ip5.ui.user.login("user", "password")

    Scenario: Créer une entité
        * ip5.ui.user.login("user", "password")
        * call read('classpath:lib/ip5/ui/tenant/create.feature') { tenant: "Démo simple" }

    Scenario: Supprimer une entité
        * ip5.ui.user.login("user", "password")
        * call read('classpath:lib/ip5/ui/tenant/delete.feature') { tenant: "Démo simple" }

    Scenario: Créer une entité
        * ip5.ui.user.login("user", "password")
        * call read('classpath:lib/ip5/ui/tenant/create.feature') { tenant: "Démo simple" }

    Scenario Outline: Créer un utilisateur ${role} et connexion avec celui-ci
        * ip5.ui.user.login("user", "password")
        * call read('classpath:lib/ip5/ui/user/create.feature') __row
        * ip5.ui.user.logout()

        * ip5.ui.user.login(username, password)

        Examples:
            | tenant      | username                 | lastName  | firstName | email                    | password | role                    |
            | Démo simple | admin@demo-simple        | Demortain | Benoit    | admin@dom.local          | a123456  | Administrateur          |
            | Démo simple | admin-entite@demo-simple | Buffin    | Christian | admin-entite@dom.local   | a123456  | Administrateur d'entité |
            | Démo simple | mpiaumier@demo-simple    | Piaumier  | Matthieu  | mpiaumier-demo@dom.local | a123456  | Aucun privilège         |
            | Démo simple | ws@demo-simple           | Service   | Web       | ws-demo@dom.local        | a123456  | Aucun privilège         |

    @issue-ip-compose-537
    Scenario Outline: Créer un user sans droit avec notif unitaire et image de signature
        * ip5.ui.user.login("admin-entite@demo-simple", "a123456")
        * call read('classpath:lib/ip5/ui/user/create.feature') __row
        * ip5.ui.user.logout()

        * ip5.api.v1.auth.login("user", "password")
        * def existingTenantId = ip5.api.v1.entity.getIdByName("<tenant>")
        * def existingUserId = ip5.api.v1.user.getIdByEmail(existingTenantId, "<email>")

        # @info: l'ajout de l'image de signature se fait par web-service
        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/images/signature - stranslucide.png', 'contentType': 'image/png' }
        When method POST
        Then status 201

        * ip5.ui.user.login(username, password)

        When ip5.ui.user.menu("{^}Profil")
        Then waitFor(ip5.ui.element.breadcrumb("Accueil / Profil"))

        When click("{^}Notifications")
            And click("thead .slider")
            And click("{^}Unitaire")
            And click(ip5.ui.locator.button("Valider"))
        Then waitFor(ip5.ui.toast.success("Préférences utilisateur éditées avec succès."))

        Examples:
            | tenant      | username               | lastName  | firstName | email                     | password | role            |
            | Démo simple | flosserand@demo-simple | Losserand | Frédéric  | flosserand-demo@dom.local | a123456  | Aucun privilège |

    Scenario Outline: Créer un bureau ${title} pour utilisateur sans droit
        * ip5.ui.user.login("admin-entite@demo-simple", "a123456")
        * call read('classpath:lib/ip5/ui/desk/create.feature') __row

        Examples:
            | tenant      | title     | shortName | owners!                    | permissions!             |
            | Démo simple | DGS       | DGS       | ['mpiaumier@demo-simple']  | ['Traiter des dossiers'] |

    Scenario Outline: Créer un bureau pour le WebService
        * ip5.ui.user.login("admin-entite@demo-simple", "a123456")
        * call read('classpath:lib/ip5/ui/desk/create.feature') __row

        Examples:
            | tenant      | title      | shortName  | owners!            | permissions!                                                                             |
            | Démo simple | WebService | WebService | ['ws@demo-simple'] | ['Créer des dossiers', 'Traiter des dossiers', 'Traiter des dossiers en fin de circuit'] |

    Scenario Outline: Créer un bureau ${title} pour utilisateur sans droit et association avec le bureau DGS
        * ip5.ui.user.login("admin-entite@demo-simple", "a123456")
        * call read('classpath:lib/ip5/ui/desk/create.feature') __row

        Examples:
            | tenant      | title     | shortName | owners!                    | permissions!             | associatedDesks! |
            | Démo simple | Président | Président | ['flosserand@demo-simple'] | ['Traiter des dossiers'] | ['DGS']          |

    Scenario Outline: Créer un circuit 1 étape de signature du bureau ${desk}
        * ip5.ui.user.login("admin-entite@demo-simple", "a123456")
        * call read('classpath:lib/ip5/ui/workflow/create_1_step.feature') __row

        Examples:
            | tenant      | name      | type      | desk      |
            | Démo simple | Signature | Signature | Président |

    Scenario Outline: Créer un circuit 1 étape de visa du bureau ${desk}
        * ip5.ui.user.login("admin-entite@demo-simple", "a123456")
        * call read('classpath:lib/ip5/ui/workflow/create_1_step.feature') __row

        Examples:
            | tenant      | name | type | desk      |
            | Démo simple | Visa | Visa | Président |

    Scenario Outline: Créer un type ACTES/PAdES
        * ip5.ui.user.login("admin-entite@demo-simple", "a123456")
        * call read('classpath:lib/ip5/ui/type/create.feature') __row

        Examples:
            | tenant      | name  | description | protocol | format | ville          | stamp! |
            | Démo simple | ACTES | ACTES       | ACTES    | PAdES  | Pont-à-Mousson | true   |

    Scenario Outline: Créer un sous-type ${type} / ${name} pour le circuit ${workflow}
        * ip5.ui.user.login("admin-entite@demo-simple", "a123456")
        * call read('classpath:lib/ip5/ui/subtype/create.feature') __row

        Examples:
            | tenant      | type  | name         | description  | workflow  |
            | Démo simple | ACTES | Délibération | Délibération | Signature |
            | Démo simple | ACTES | Visa         | Visa         | Visa      |
