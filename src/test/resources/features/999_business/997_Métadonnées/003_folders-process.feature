@business @metadonnees @folder-process @proposal
Feature: Traitement de dossiers pour le paramétrage métier "Métadonnées"

    Scenario Outline: Traitement du dossier "${folder}" en individuel via UI par ecapucine
        * def params =
"""
{
    tenant: "Métadonnées",
    annotation: "visa",
    username: "ecapucine",
    desktop: "Capucine",
    folder: "#(folder)",
    metadata: "#(ip.metadatas.map['<folder>'])"
}
"""
        * configure driver = ui.driver.configure
        * driver baseUrl + ui.url.logout
        * ui.user.login(params.username, 'a123456')

        * click("{a}" + params.desktop)

        # Filtre sur le nom du dossier
        * click(ui.locator.tray.filter.toggle)
        * input(ui.locator.input('Titre'), '<folder>')
        * click(ui.locator.tray.filter.apply)

        * click("{a}<folder>")

        * waitFor(ui.element.breadcrumb("Accueil / " + params.tenant + " / " + params.desktop + " / " + params.folder))

        * click("//*[contains(normalize-space(text()), '" + action + "')]/ancestor-or-self::button")

        * ui.folder.annotate.both(params.username, action, params.folder)
        * v5.business.ui.metadatas.fill(ip.metadatas.map['<folder>'])

        * click("{^}Valider")
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * waitFor(ui.toast.success("action " + action + " sur le dossier " + folder + " a été effectuée avec succès"))

        Examples:
            | folder                                                | action |
            | Individuel - Rejet - Aucune métadonnée                | Rejet  |
            | Individuel - Rejet - Booleen rejet                    | Rejet  |
            | Individuel - Rejet - Booleen validation               | Rejet  |
            | Individuel - Rejet - Booleen rejet et validation      | Rejet  |
            | Individuel - Rejet - Texte rejet                      | Rejet  |
            | Individuel - Rejet - Texte validation                 | Rejet  |
            | Individuel - Rejet - Texte rejet et validation        | Rejet  |
            | Individuel - Rejet - Toutes validation et rejet       | Rejet  |
            | Individuel - Validation - Aucune métadonnée           | Visa   |
            | Individuel - Validation - Booleen rejet               | Visa   |
            | Individuel - Validation - Booleen validation          | Visa   |
            | Individuel - Validation - Booleen rejet et validation | Visa   |
            | Individuel - Validation - Texte rejet                 | Visa   |
            | Individuel - Validation - Texte validation            | Visa   |
            | Individuel - Validation - Texte rejet et validation   | Visa   |
            | Individuel - Validation - Toutes validation et rejet  | Visa   |

    Scenario Outline: Traitement du dossier "${folder}" en liste via UI par ecapucine
        * def params =
"""
{
    tenant: "Métadonnées",
    annotation: "visa",
    username: "ecapucine",
    desktop: "Capucine",
    folder: "#(folder)",
    metadata: "#(ip.metadatas.map['<folder>'])"
}
"""
        * configure driver = ui.driver.configure
        * driver baseUrl + ui.url.logout
        * ui.user.login(params.username, 'a123456')

        * click("{a}" + params.desktop)

        # Filtre sur le nom du dossier
        * click(ui.locator.tray.filter.toggle)
        * input(ui.locator.input('Titre'), '<folder>')
        * click(ui.locator.tray.filter.apply)

        * def folderXpath = "//table//a[normalize-space(text()='<folder>')]"
        * waitFor(folderXpath)
        * def checkboxXpath = folderXpath + "//ancestor::tr//input[@type='checkbox']"
        * waitFor(checkboxXpath)
#        * karate.log(value(checkboxXpath))
        #* mouse().move(checkboxXpath).click()
        * driver.screenshot()
        * waitFor(checkboxXpath).click()
        * waitFor("//span[contains(normalize-space(text()), '" + action + "')]").click()

        * ui.folder.annotate.both(params.username, action, params.folder)
        * v5.business.ui.metadatas.fill(ip.metadatas.map['<folder>'])

        * driver.screenshot()
        * waitForEnabled("{^}Valider").click()
        * driver.screenshot()
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * driver.screenshot()
        # @fixme: ne fonctionne pas tout le temps, alors que le toaster apparaît bien sur l'image
        #* waitFor(ui.toast.success("action " + action + " sur le dossier " + folder + " a été effectuée avec succès"))

        Examples:
            | folder                                           | action |
            | Liste - Rejet - Aucune métadonnée                | Rejet  |
            | Liste - Rejet - Booleen rejet                    | Rejet  |
            | Liste - Rejet - Booleen validation               | Rejet  |
            | Liste - Rejet - Booleen rejet et validation      | Rejet  |
            | Liste - Rejet - Texte rejet                      | Rejet  |
            | Liste - Rejet - Texte validation                 | Rejet  |
            | Liste - Rejet - Texte rejet et validation        | Rejet  |
            | Liste - Rejet - Toutes validation et rejet       | Rejet  |
            | Liste - Validation - Aucune métadonnée           | Visa   |
            | Liste - Validation - Booleen rejet               | Visa   |
            | Liste - Validation - Booleen validation          | Visa   |
            | Liste - Validation - Booleen rejet et validation | Visa   |
            | Liste - Validation - Texte rejet                 | Visa   |
            | Liste - Validation - Texte validation            | Visa   |
            | Liste - Validation - Texte rejet et validation   | Visa   |
            | Liste - Validation - Toutes validation et rejet  | Visa   |

    Scenario Outline: Traitement du dossier "${folder}" en liste via UI par ecapucine
        * def params =
"""
{
    tenant: "Métadonnées",
    annotation: "visa",
    username: "ecapucine",
    desktop: "Capucine",
    folder: "#(folder)",
    metadata: "#(ip.metadatas.map['<folder>'])"
}
"""
        * configure driver = ui.driver.configure
        * driver baseUrl + ui.url.logout
        * ui.user.login(params.username, 'a123456')

        * click("{a}" + params.desktop)

            # Filtre sur le nom du dossier
        * click(ui.locator.tray.filter.toggle)
        * input(ui.locator.input('Titre'), '<folder>')
        * click(ui.locator.tray.filter.apply)

        * pause(10)
        * driver.screenshot()

#        * def folderXpath = "//table//a[normalize-space(text()='<folder>')]"
#        * waitFor(folderXpath)
        * def checkboxXpath = "//table//th//input[@type='checkbox']"
        * waitFor(checkboxXpath)

        * waitFor(checkboxXpath).click()
        * driver.screenshot()

        * waitFor("//span[contains(normalize-space(text()), '" + action + "')]").click()

        * ui.folder.annotate.both(params.username, action, params.folder)

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

        * def metadatas = mergeMetadatasStartingWith(ip.metadatas.map, '<folder>')
        * karate.log(metadatas)
        * v5.business.ui.metadatas.fill(metadatas)

        * driver.screenshot()
        * waitForEnabled("{^}Valider").click()
        * driver.screenshot()
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * driver.screenshot()
        # @fixme: ne fonctionne pas tout le temps, alors que le toaster apparaît bien sur l'image
        #* waitFor(ui.toast.success("action " + action + " sur le dossier " + folder + " a été effectuée avec succès"))

        Examples:
            | folder              | action |
            | Groupe - Rejet      | Rejet  |
            | Groupe - Validation | Visa   |
