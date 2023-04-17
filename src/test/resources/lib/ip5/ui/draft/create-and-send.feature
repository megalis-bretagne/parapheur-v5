@karate-function
Feature: UI draft lib

    Scenario: Ajout d'un brouillon et envoi du dossier
        # @fixme: je n'arrive pas à utiliser les ng-select
        * ip5.ui.user.login(username, password)
        * waitFor("{^}" + desk).click()
        * waitFor("{^}Créer un dossier").click()
        * waitFor("#fileInput")
        * driver.inputFile('#fileInput', document)

#        * click("#typeSelector .ng-select-clearable .ng-input")
#        * click(".ng-select-clearable .ng-input")
#        * click("ng-select")
#        * input("#typeSelector ng-select input", type)
#        * click("#typeSelector ng-select input")
#        * click("#typeSelector ng-select .ng-placeholder")

#        * click(".ng-select-clearable .ng-input")

#        * click(".ng-option")


        * waitFor("//*[@id='typeSelector']//*[@class='ng-input']").click()
        * mouse().move("#typeSelector").go();
        * waitFor("#typeSelector .ng-select-clearable .ng-input").click()

        * waitFor("//*[contains(@class, 'ng-option')]//*[normalize-space(text())='" + type + "']/ancestor::*[contains(@class, 'ng-option')]").click()

        * waitFor("//*[@id='subtypeSelector']").click()
        * waitFor("//*[contains(@class, 'ng-option')]//*[normalize-space(text())='" + subtype + "']/ancestor::*[contains(@class, 'ng-option')]").click()

