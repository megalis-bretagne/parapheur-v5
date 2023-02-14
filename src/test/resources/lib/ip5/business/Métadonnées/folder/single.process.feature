@business @metadonnees @folder @ignore
Feature: ...

    Scenario: ...
        * def defaults =
"""
{
    tenant: "Métadonnées",
    annotation: "visa",
    username: "ecapucine",
    password: "a123456",
    desktop: "Capucine"
}
"""
        * def params = karate.merge(defaults, __arg)
        * params["metadata"] = ip.business.metadonnees.map[params.folder]

        * configure driver = ip.ui.driver.configure
        * driver baseUrl + ip5.ui.url.logout
        * ip5.ui.user.login(params.username, params.password)

        * click("{a}" + params.desktop)

        # Filtre sur le type, sous-type et nom du dossier
        * click(ip5.ui.locator.tray.filter.toggle)
        * ip5.ui.ngSelect("//app-type-selector//ng-select", params.type)
        * ip5.ui.ngSelect("//app-subtype-selector//ng-select", params.subtype)
        * input(ip5.ui.locator.input('Titre'), params.folder)
        * click(ip5.ui.locator.tray.filter.apply)

        * click("{a}" + params.folder)

        * waitFor(ip5.ui.element.breadcrumb("Accueil / " + params.tenant + " / " + params.desktop + " / " + params.folder))

        * click("//*[contains(normalize-space(text()), '" + params.action + "')]/ancestor-or-self::button")

        * ip5.ui.folder.annotate.both(params.username, params.action, params.folder)
        * ip5.business.ui.metadatas.fill(ip.business.metadonnees.map[params.folder])

        * click("{^}Valider")
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Métadonnées / Capucine / Dossiers à traiter"))
        * waitFor(ip5.ui.toast.success("action " + params.action + " sur le dossier " + params.folder + " a été effectuée avec succès"))

#        * def folderXpath = "//table//a[normalize-space(text()='" + params.folder + "')]"
#        * waitFor(folderXpath)
#        * def checkboxXpath = folderXpath + "//ancestor::tr//input[@type='checkbox']"
#        #* waitFor(checkboxXpath)
#
#        #* driver.screenshot()
#        * waitFor(checkboxXpath).click()
#        * waitFor("//span[contains(normalize-space(text()), '" + params.action + "')]").click()
#
#        * ip5.ui.folder.annotate.both(params.username, params.action, params.folder)
#        * ip5.business.ui.metadatas.fill(params.metadata)
#
#        * driver.screenshot()
#        * waitForEnabled("{^}Valider").click()
#        #        * driver.screenshot()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Métadonnées / Capucine / Dossiers à traiter"))
#        #        * driver.screenshot()
#        # @fixme: ne fonctionne pas tout le temps, alors que le toaster apparaît bien sur l'image
#        #* waitFor(ip5.ui.toast.success("action " + action + " sur le dossier " + folder + " a été effectuée avec succès"))
