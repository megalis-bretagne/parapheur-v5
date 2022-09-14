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

        # Filtre sur le nom du dossier
        * click(ui.locator.tray.filter.toggle)
        * input(ui.locator.input('Titre'), params.folder)
        * click(ui.locator.tray.filter.apply)

        * def checkboxXpath = "//table//th//input[@type='checkbox']"
        * waitFor(checkboxXpath)

        * waitFor(checkboxXpath).click()

        * waitFor("//span[contains(normalize-space(text()), '" + params.action + "')]").click()

        * ui.folder.annotate.both(params.username, params.action, params.folder)

        * def mergeMetadatasStartingWith =
"""
function(obj, start) {
    var key, result = {};
    for(key in obj) {
        if(key.startsWith(start) === true) {
            result = karate.merge(result, obj[key]);
        }
    }
    return result;
}
"""

        * def metadatas = mergeMetadatasStartingWith(ip.metadatas.map, params.folder)
        * v5.business.ui.metadatas.fill(metadatas)

        * driver.screenshot()
        * waitForEnabled("{^}Valider").click()
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        # @fixme: ne fonctionne pas tout le temps, alors que le toaster apparaît bien sur l'image
        #* waitFor(ui.toast.success("action " + action + " sur le dossier " + folder + " a été effectuée avec succès"))
