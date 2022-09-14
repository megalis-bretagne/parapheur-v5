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
        * params["metadata"] = ip.metadatas.map[params.folder]

        * configure driver = ui.driver.configure
        * driver baseUrl + ui.url.logout
        * ui.user.login(params.username, params.password)

        * click("{a}" + params.desktop)

        # Filtre sur le type, sous-type et nom du dossier
        * click(ui.locator.tray.filter.toggle)
        * ui.ngSelect("//app-type-selector//ng-select", params.type)
        * ui.ngSelect("//app-subtype-selector//ng-select", params.subtype)
        * input(ui.locator.input('Titre'), params.folder)
        * click(ui.locator.tray.filter.apply)

        * def folderXpath = "//table//a[normalize-space(text()='" + params.folder + "')]"
        * waitFor(folderXpath)
        * def checkboxXpath = folderXpath + "//ancestor::tr//input[@type='checkbox']"
        #* waitFor(checkboxXpath)

        #* driver.screenshot()
        * waitFor(checkboxXpath).click()
        * waitFor("//span[contains(normalize-space(text()), '" + params.action + "')]").click()

        * ui.folder.annotate.both(params.username, params.action, params.folder)
        * v5.business.ui.metadatas.fill(params.metadata)

        * driver.screenshot()
        * waitForEnabled("{^}Valider").click()
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
