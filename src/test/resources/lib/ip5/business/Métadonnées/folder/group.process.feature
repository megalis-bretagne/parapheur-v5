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
        * params["metadata"] = ip.businnes.metadonnees.map[params.folder]

        * configure driver = ip.ui.driver.configure
        * driver baseUrl + ip5.ui.url.logout
        * ip5.ui.user.login(params.username, params.password)

        * click("{a}" + params.desktop)

        # Filtre sur le nom du dossier
        * click(ip5.ui.locator.tray.filter.toggle)
        * input(ip5.ui.locator.input('Titre'), params.folder)
        * click(ip5.ui.locator.tray.filter.apply)

        * def checkboxXpath = "//table//th//input[@type='checkbox']"
        * waitFor(checkboxXpath)

        * waitFor(checkboxXpath).click()

        * waitFor("//span[contains(normalize-space(text()), '" + params.action + "')]").click()

        * ip5.ui.folder.annotate.both(params.username, params.action, params.folder)

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

        * def metadatas = mergeMetadatasStartingWith(ip.businnes.metadonnees.map, params.folder)
        * ip5.business.ui.metadatas.fill(metadatas)

        * driver.screenshot()
        * waitForEnabled("{^}Valider").click()
        * waitFor(ip5.ui.element.breadcrumb("Accueil / Bureaux"))
        # @fixme: ne fonctionne pas tout le temps, alors que le toaster apparaît bien sur l'image
        #* waitFor(ip5.ui.toast.success("action " + action + " sur le dossier " + folder + " a été effectuée avec succès"))
