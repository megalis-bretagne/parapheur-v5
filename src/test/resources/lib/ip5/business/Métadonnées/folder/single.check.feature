@business @metadonnees @folder @ignore
Feature: ...

    Scenario: ...
        * configure driver = ui.driver.configure
        * driver baseUrl + ui.url.logout

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
        * params["metadatas"] = ip.metadatas.map[params.folder]
        * params["state"] = getState(__arg.action)
        * karate.log(params)

        * configure driver = ui.driver.configure
        * driver baseUrl + ui.url.logout
        * ui.user.login(params.username, params.password)

        * click("{a}" + params.desktop)
        * click("//span[contains(@class, 'badge badge-" + params.state + " desk-badge')]")

        # Filtre sur le nom du dossier
        * click(ui.locator.tray.filter.toggle)
        * input(ui.locator.input('Titre'), params.folder)
        * click(ui.locator.tray.filter.apply)

        * click("{a}" + params.folder)

        * waitFor(ui.element.breadcrumb("Accueil / " + params.tenant + " / " + params.desktop + " / " + params.folder))

        #* waitFor("//strong[text()='Métadonnées']");
        * def metadatas = ui.getMetadatas()
        * match metadatas == params.metadatas
