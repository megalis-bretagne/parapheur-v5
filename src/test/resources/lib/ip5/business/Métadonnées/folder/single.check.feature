@business @metadonnees @folder @ignore
Feature: ...

    Scenario: ...
        # * configure driver = ip.ui.driver.configure
        * driver baseUrl + ip5.ui.url.logout

        * def getState = function(action) { return action === 'Rejet' ? 'rejected' : 'finished'; }
        * def params =
"""
{
    tenant: "Métadonnées",
    username: "ws-meta",
    password: "a123456a123456",
    date: "2022-09-01",
    desktop: "WebService"
}
"""
        * params["folder"] = __arg.mode + " - " + __arg.action + " - " + __arg.subtype
        * params["metadatas"] = ip.business.metadonnees.map[params.folder]
        * params["state"] = getState(__arg.action)
        * karate.log(params)

        # * configure driver = ip.ui.driver.configure
        * driver baseUrl + ip5.ui.url.logout
        * ip5.ui.user.login(params.username, params.password)

        * waitFor("//span[contains(@class, 'badge badge-" + params.state + " desk-badge')]").click()

        # Filtre sur le nom du dossier
        * click(ip5.ui.locator.tray.filter.toggle)
        * input(ip5.ui.locator.input('Titre'), [params.folder, Key.ENTER], 200)
        * click(ip5.ui.locator.tray.filter.apply)

        * waitFor("{a}" + params.folder).click()

        * waitFor(ip5.ui.element.breadcrumb("Accueil / " + params.tenant + " / " + params.desktop + " / " + params.folder))

        #* waitFor("//strong[text()='Métadonnées']");
        * ip.pauseMillis(300)
        * def metadatas = ip5.ui.getMetadatas()
        * match metadatas == params.metadatas
