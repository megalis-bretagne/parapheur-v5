@ip-web @l10n @demo-approfondie-bde
Feature: 001 - Scénario de démo (utilisation approfondie), partie administration
    # @fixme: entité Benoit ?
    Background:
        * configure driver = ui.driver.configure
        * driver baseUrl + ui.url.logout

    Scenario: Créer une entité
        * ui.user.login("user", "password")
        * call read('classpath:lib/ui/tenant/create.feature') { tenant: "Démo approfondie" }
