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
            | tenant | username   | lastName | firstName | email          | password | role            |
            | Démo   | user1@demo | Dominici | Roger     | user@dom.local | a123456  | Aucun privilège |
