@business @metadonnees @folder @ignore
Feature: ...

    Scenario: ...
        * configure driver = ip.ui.driver.configure
        * driver baseUrl + ip5.ui.url.logout

        * def getState = function(action) { return action === 'Rejet' ? 'rejected' : 'finished'; }
        * def params =
"""
{
    tenant: "Métadonnées",
    username: "ws-meta",
    password: "a123456",
    desktop: "WebService"
}
"""
        * params["folder"] = __arg.mode + " - " + __arg.action + " - " + __arg.subtype
        * params["metadatas"] = ip.businnes.metadonnees.map[params.folder]
        * params["state"] = getState(__arg.action)
        * karate.log(params)

        * configure driver = ip.ui.driver.configure
        * driver baseUrl + ip5.ui.url.logout
        * ip5.ui.user.login(params.username, params.password)

        * click("{a}" + params.desktop)
        * click("//span[contains(@class, 'badge badge-" + params.state + " desk-badge')]")

        # Filtre sur le nom du dossier
        * click(ip5.ui.locator.tray.filter.toggle)
        * input(ip5.ui.locator.input('Titre'), params.folder)
        * click(ip5.ui.locator.tray.filter.apply)

        * click("{a}" + params.folder)

        * waitFor(ip5.ui.element.breadcrumb("Accueil / " + params.tenant + " / " + params.desktop + " / " + params.folder))

        #* waitFor("//strong[text()='Métadonnées']");
        * def metadatas = ip5.ui.getMetadatas()
        * match metadatas == params.metadatas
