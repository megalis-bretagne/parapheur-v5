@ip-web @l10n @demo-bde
Feature: 001 - Administration

    Background:
        * configure driver = ui.driver.configure
        * driver baseUrl + ui.url.logout

    Scenario: Connexion avec un superadmin
        * ui.user.login("user", "password")

    Scenario: Créer une entité
        * ui.user.login("user", "password")
        * call read('classpath:lib/ui/tenant/create.feature') { tenant: "Démo" }

    Scenario: Supprimer une entité
        * ui.user.login("user", "password")
        * call read('classpath:lib/ui/tenant/delete.feature') { tenant: "Démo" }

    Scenario: Créer une entité
        * ui.user.login("user", "password")
        * call read('classpath:lib/ui/tenant/create.feature') { tenant: "Démo" }

    Scenario Outline: Créer un utilisateur ${role} et connexion avec celui-ci
        * ui.user.login("user", "password")
        * call read('classpath:lib/ui/user/create.feature') __row
        * ui.user.logout()

        * ui.user.login(username, password)

        Examples:
            | tenant | username          | lastName  | firstName | email                  | password | role                    |
            | Démo   | admin@demo        | Demortain | Benoit    | admin@dom.local        | a123456  | Administrateur          |
            | Démo   | admin-entite@demo | Buffin    | Christian | admin-entite@dom.local | a123456  | Administrateur d'entité |

    Scenario Outline: Créer un user sans droit avec notif unitaire
        * ui.user.login("admin-entite@demo", "a123456")
        * call read('classpath:lib/ui/user/create.feature') __row
        * ui.user.logout()

        * ui.user.login(username, password)

        When ui.user.menu("{^}Profil")
        Then waitFor(ui.element.breadcrumb("Accueil / Profil"))

        When click("{^}Notifications")
            And click("thead .slider")
            And click("{^}Unitaire")
            And click(ui.locator.button("Valider"))
        Then waitFor(ui.toast.success("Préférences utilisateur éditées avec succès."))

        Examples:
            | tenant | username   | lastName | firstName | email           | password | role            |
            | Démo   | user1@demo | Dominici | Roger     | user1@dom.local | a123456  | Aucun privilège |

    # @info: l'ajout de l'image de siagnature se fait par web-service
    Scenario Outline: Créer un user sans droit avec une image de signature
        * ui.user.login("admin-entite@demo", "a123456")
        * call read('classpath:lib/ui/user/create.feature') __row
        * ui.user.logout()

        * api_v1.auth.login("user", "password")
        * def existingTenantId = api_v1.entity.getIdByName("<tenant>")
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, "<email>")

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: 'classpath:files/images/signature - stranslucide.png', 'contentType': 'image/png' }
        When method POST
        Then status 201

        Examples:
            | tenant | username   | lastName | firstName | email           | password | role            |
            | Démo   | user2@demo | Sébeille | Edmond    | user2@dom.local | a123456  | Aucun privilège |

    Scenario Outline: Créer un utilisateur WebService
        * ui.user.login("admin-entite@demo", "a123456")
        * call read('classpath:lib/ui/user/create.feature') __row

        Examples:
            | tenant | username | lastName | firstName | email             | password | role            |
            | Démo   | ws@demo  | Service  | Web       | ws-demo@dom.local | a123456  | Aucun privilège |

    Scenario Outline: Créer un bureau pour visa pour le user sans droit
        * ui.user.login("admin-entite@demo", "a123456")
        * call read('classpath:lib/ui/desk/create.feature') __row

        Examples:
            | tenant | title  | shortName | owners!        | permissions!             |
            | Démo   | Viseur | Viseur    | ['user1@demo'] | ['Traiter des dossiers'] |

    Scenario Outline: Créer un bureau pour le WebService
        * ui.user.login("admin-entite@demo", "a123456")
        * call read('classpath:lib/ui/desk/create.feature') __row

        Examples:
            | tenant | title      | shortName  | owners!     | permissions!                                                                             |
            | Démo   | WebService | WebService | ['ws@demo'] | ['Créer des dossiers', 'Traiter des dossiers', 'Traiter des dossiers en fin de circuit'] |

