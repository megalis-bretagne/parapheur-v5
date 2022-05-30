@ip-web @l10n @demo-bde
Feature: 002 - Scénario de démo simple, partie utilisation

    Background:
        * configure driver = ui.driver.configure
        * driver baseUrl + ui.url.logout
@wip
    Scenario Outline: Envoi d'un dossier dans le circuit
        * ui.user.login(username, password)
        * click("{^}" + desk)
        * click("{^}Créer un dossier")
        * waitFor("#fileInput")
        * driver.inputFile('#fileInput', document)

#        * click("#typeSelector .ng-select-clearable .ng-input")
#        * click(".ng-select-clearable .ng-input")
#        * click("ng-select")
#        * input("#typeSelector ng-select input", type)
#        * click("#typeSelector ng-select input")
#        * click("#typeSelector ng-select .ng-placeholder")

#        * click(".ng-select-clearable .ng-input")
#        * pause(5)
#        * click(".ng-option")
#        * pause(5)

#        * click("//*[@id='typeSelector']//*[@class='ng-input']")
#        * mouse().move("#typeSelector").go();
#        * click("#typeSelector .ng-select-clearable .ng-input")
#        * pause(5)
#        * click("//*[contains(@class, 'ng-option')]//*[normalize-space(text())='" + type + "']/ancestor::*[contains(@class, 'ng-option')]")
#        * pause(5)
#        * click("//*[@id='subtypeSelector']")
#        * click("//*[contains(@class, 'ng-option')]//*[normalize-space(text())='" + subtype + "']/ancestor::*[contains(@class, 'ng-option')]")
#        * pause(5)

        Examples:
            | username | password | desk       | document                                                | type  | subtype | name |
            | ws@demo  | a123456  | WebService | classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf | ACTES | Visa    | kkk  |
