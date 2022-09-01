@business @metadonnees @folder @proposal
Feature: Création de dossiers pour le paramétrage métier "Métadonnées"

    Background:
        * def types =
"""
{
    booleen: "BOOLEAN",
    date: "DATE",
    date_restreinte: "DATE",
    nombre_virgule: "FLOAT",
    nombre_virgule_restreint: "FLOAT",
    nombre_entier: "INTEGER",
    nombre_entier_restreint: "INTEGER",
    texte: "TEXT",
    texte_restreint: "TEXT",
    url: "TEXT",
    url_restreint: "TEXT"
}
"""
        * def fields =
"""
{
    booleen: "Booléen",
    date: "Date",
    date_restreinte: "Date restreinte",
    nombre_virgule: "Nombre à virgule",
    nombre_virgule_restreint: "Nombre à virgule restreint",
    nombre_entier: "Nombre entier",
    nombre_entier_restreint: "Nombre entier restreint",
    texte: "Texte",
    texte_restreint: "Texte restreint",
    url: "URL",
    url_restreint: "URL restreint"
}
"""
        * def inverse =
"""
{
    "Booléen": "booleen",
    "Date": "date",
    "Date restreinte": "date_restreinte",
    "Nombre à virgule": "nombre_virgule",
    "Nombre à virgule restreint": "nombre_virgule_restreint",
    "Nombre entier": "nombre_entier",
    "Nombre entier restreint": "nombre_entier_restreint",
    "Texte": "texte",
    "Texte restreint": "texte_restreint",
    "URL": "url",
    "URL restreint": "url_restreint"
}
"""
        * def tmp =
"""
{
    "Rejet - Aucune métadonnée": {},
    "Rejet - Booleen rejet": {booleen: false},
    "Rejet - Booleen validation": {},
    "Rejet - Booleen rejet et validation": {booleen: false},
    "Rejet - Texte rejet": {texte: "Texte rejet"},
    "Rejet - Texte validation": {},
    "Rejet - Texte rejet et validation": {texte: "Texte rejet"},
    "Rejet - Toutes validation et rejet": {
        booleen: false,
        date: "2022-09-01",
        date_restreinte: "2022-01-15",
        nombre_virgule: 0.33,
        nombre_virgule_restreint: 0,
        nombre_entier: 0,
        nombre_entier_restreint: 0,
        texte: "Texte rejet",
        texte_restreint: "a",
        url: "https://perdu.com/",
        url_restreint: "http://www.lesoir.be",
    },
    "Validation - Aucune métadonnée": {},
    "Validation - Booleen rejet": {},
    "Validation - Booleen validation": {booleen: true},
    "Validation - Booleen rejet et validation": {booleen: true},
    "Validation - Texte rejet": {},
    "Validation - Texte validation": {texte: "Texte validation"},
    "Validation - Texte rejet et validation": {texte: "Texte validation"},
    "Validation - Toutes validation et rejet": {
        booleen: true,
        date: "2022-09-02",
        date_restreinte: "2022-02-15",
        nombre_virgule: 0.77,
        nombre_virgule_restreint: 1.5,
        nombre_entier: 1,
        nombre_entier_restreint: 2,
        texte: "Texte validation",
        texte_restreint: "b",
        url: "https://dernierepage.com/",
        url_restreint: "https://www.libriciel.fr/nos-logiciels/",
    }
}
"""
        * def map =
"""
{
    "Groupe - Rejet - Aucune métadonnée": "#(tmp['Rejet - Aucune métadonnée'])",
    "Groupe - Rejet - Booleen rejet": "#(tmp['Rejet - Booleen rejet'])",
    "Groupe - Rejet - Booleen validation": "#(tmp['Rejet - Booleen validation'])",
    "Groupe - Rejet - Booleen rejet et validation": "#(tmp['Rejet - Booleen rejet et validation'])",
    "Groupe - Rejet - Texte rejet": "#(tmp['Rejet - Texte rejet'])",
    "Groupe - Rejet - Texte validation": "#(tmp['Rejet - Texte validation'])",
    "Groupe - Rejet - Texte rejet et validation": "#(tmp['Rejet - Texte rejet et validation'])",
    "Groupe - Rejet - Toutes validation et rejet": "#(tmp['Rejet - Toutes validation et rejet'])",
    "Groupe - Validation - Aucune métadonnée": "#(tmp['Validation - Aucune métadonnée'])",
    "Groupe - Validation - Booleen rejet": "#(tmp['Validation - Booleen rejet'])",
    "Groupe - Validation - Booleen validation": "#(tmp['Validation - Booleen validation'])",
    "Groupe - Validation - Booleen rejet et validation": "#(tmp['Validation - Booleen rejet et validation'])",
    "Groupe - Validation - Texte rejet": "#(tmp['Validation - Texte rejet'])",
    "Groupe - Validation - Texte validation": "#(tmp['Validation - Texte validation'])",
    "Groupe - Validation - Texte rejet et validation": "#(tmp['Validation - Texte rejet et validation'])",
    "Groupe - Validation - Toutes validation et rejet": "#(tmp['Validation - Toutes validation et rejet'])",
    "Individuel - Rejet - Aucune métadonnée": "#(tmp['Rejet - Aucune métadonnée'])",
    "Individuel - Rejet - Booleen rejet": "#(tmp['Rejet - Booleen rejet'])",
    "Individuel - Rejet - Booleen validation": "#(tmp['Rejet - Booleen validation'])",
    "Individuel - Rejet - Booleen rejet et validation": "#(tmp['Rejet - Booleen rejet et validation'])",
    "Individuel - Rejet - Texte rejet": "#(tmp['Rejet - Texte rejet'])",
    "Individuel - Rejet - Texte validation": "#(tmp['Rejet - Texte validation'])",
    "Individuel - Rejet - Texte rejet et validation": "#(tmp['Rejet - Texte rejet et validation'])",
    "Individuel - Rejet - Toutes validation et rejet": "#(tmp['Rejet - Toutes validation et rejet'])",
    "Individuel - Validation - Aucune métadonnée": "#(tmp['Validation - Aucune métadonnée'])",
    "Individuel - Validation - Booleen rejet": "#(tmp['Validation - Booleen rejet'])",
    "Individuel - Validation - Booleen validation": "#(tmp['Validation - Booleen validation'])",
    "Individuel - Validation - Booleen rejet et validation": "#(tmp['Validation - Booleen rejet et validation'])",
    "Individuel - Validation - Texte rejet": "#(tmp['Validation - Texte rejet'])",
    "Individuel - Validation - Texte validation": "#(tmp['Validation - Texte validation'])",
    "Individuel - Validation - Texte rejet et validation": "#(tmp['Validation - Texte rejet et validation'])",
    "Individuel - Validation - Toutes validation et rejet": "#(tmp['Validation - Toutes validation et rejet'])",
    "Liste - Rejet - Aucune métadonnée": "#(tmp['Rejet - Aucune métadonnée'])",
    "Liste - Rejet - Booleen rejet": "#(tmp['Rejet - Booleen rejet'])",
    "Liste - Rejet - Booleen validation": "#(tmp['Rejet - Booleen validation'])",
    "Liste - Rejet - Booleen rejet et validation": "#(tmp['Rejet - Booleen rejet et validation'])",
    "Liste - Rejet - Texte rejet": "#(tmp['Rejet - Texte rejet'])",
    "Liste - Rejet - Texte validation": "#(tmp['Rejet - Texte validation'])",
    "Liste - Rejet - Texte rejet et validation": "#(tmp['Rejet - Texte rejet et validation'])",
    "Liste - Rejet - Toutes validation et rejet": "#(tmp['Rejet - Toutes validation et rejet'])",
    "Liste - Validation - Aucune métadonnée": "#(tmp['Validation - Aucune métadonnée'])",
    "Liste - Validation - Booleen rejet": "#(tmp['Validation - Booleen rejet'])",
    "Liste - Validation - Booleen validation": "#(tmp['Validation - Booleen validation'])",
    "Liste - Validation - Booleen rejet et validation": "#(tmp['Validation - Booleen rejet et validation'])",
    "Liste - Validation - Texte rejet": "#(tmp['Validation - Texte rejet'])",
    "Liste - Validation - Texte validation": "#(tmp['Validation - Texte validation'])",
    "Liste - Validation - Texte rejet et validation": "#(tmp['Validation - Texte rejet et validation'])",
    "Liste - Validation - Toutes validation et rejet": "#(tmp['Validation - Toutes validation et rejet'])",
}
"""

    Scenario Outline: Create 1 "${subtype}" folders without annex
        * def params =
"""
{
    tenant: 'Métadonnées',
    desktop: 'WebService',
    type: 'PAdES',
    subtype: '<subtype>',
    mainFile: 'classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf',
    nameTemplate: '<nameTemplate>',
    annotation: 'démarrage',
    username: '<username>',
}
"""
        * api_v1.auth.login('user', 'password')
        * def folders = api_v1.desk.draft.getPayloadMonodoc(params, 1, {}, 1)
        * api_v1.auth.login('ws-meta', 'a123456')
        * def result = call read('classpath:lib/api/draft/create-and-send-monodoc-without-annex.feature') folders

        Examples:
            | subtype                     | nameTemplate                                          |
            | Aucune métadonnée           | Groupe - Rejet - Aucune métadonnée                    |
            | Booleen rejet               | Groupe - Rejet - Booleen rejet                        |
            | Booleen validation          | Groupe - Rejet - Booleen validation                   |
            | Booleen rejet et validation | Groupe - Rejet - Booleen rejet et validation          |
            | Texte rejet                 | Groupe - Rejet - Texte rejet                          |
            | Texte validation            | Groupe - Rejet - Texte validation                     |
            | Texte rejet et validation   | Groupe - Rejet - Texte rejet et validation            |
            | Toutes validation et rejet  | Groupe - Rejet - Toutes validation et rejet           |
            | Aucune métadonnée           | Groupe - Validation - Aucune métadonnée               |
            | Booleen rejet               | Groupe - Validation - Booleen rejet                   |
            | Booleen validation          | Groupe - Validation - Booleen validation              |
            | Booleen rejet et validation | Groupe - Validation - Booleen rejet et validation     |
            | Texte rejet                 | Groupe - Validation - Texte rejet                     |
            | Texte validation            | Groupe - Validation - Texte validation                |
            | Texte rejet et validation   | Groupe - Validation - Texte rejet et validation       |
            | Toutes validation et rejet  | Groupe - Validation - Toutes validation et rejet      |
            | Aucune métadonnée           | Individuel - Rejet - Aucune métadonnée                |
            | Booleen rejet               | Individuel - Rejet - Booleen rejet                    |
            | Booleen validation          | Individuel - Rejet - Booleen validation               |
            | Booleen rejet et validation | Individuel - Rejet - Booleen rejet et validation      |
            | Texte rejet                 | Individuel - Rejet - Texte rejet                      |
            | Texte validation            | Individuel - Rejet - Texte validation                 |
            | Texte rejet et validation   | Individuel - Rejet - Texte rejet et validation        |
            | Toutes validation et rejet  | Individuel - Rejet - Toutes validation et rejet       |
            | Aucune métadonnée           | Individuel - Validation - Aucune métadonnée           |
            | Booleen rejet               | Individuel - Validation - Booleen rejet               |
            | Booleen validation          | Individuel - Validation - Booleen validation          |
            | Booleen rejet et validation | Individuel - Validation - Booleen rejet et validation |
            | Texte rejet                 | Individuel - Validation - Texte rejet                 |
            | Texte validation            | Individuel - Validation - Texte validation            |
            | Texte rejet et validation   | Individuel - Validation - Texte rejet et validation   |
            | Toutes validation et rejet  | Individuel - Validation - Toutes validation et rejet  |
            | Aucune métadonnée           | Liste - Rejet - Aucune métadonnée                     |
            | Booleen rejet               | Liste - Rejet - Booleen rejet                         |
            | Booleen validation          | Liste - Rejet - Booleen validation                    |
            | Booleen rejet et validation | Liste - Rejet - Booleen rejet et validation           |
            | Texte rejet                 | Liste - Rejet - Texte rejet                           |
            | Texte validation            | Liste - Rejet - Texte validation                      |
            | Texte rejet et validation   | Liste - Rejet - Texte rejet et validation             |
            | Toutes validation et rejet  | Liste - Rejet - Toutes validation et rejet            |
            | Aucune métadonnée           | Liste - Validation - Aucune métadonnée                |
            | Booleen rejet               | Liste - Validation - Booleen rejet                    |
            | Booleen validation          | Liste - Validation - Booleen validation               |
            | Booleen rejet et validation | Liste - Validation - Booleen rejet et validation      |
            | Texte rejet                 | Liste - Validation - Texte rejet                      |
            | Texte validation            | Liste - Validation - Texte validation                 |
            | Texte rejet et validation   | Liste - Validation - Texte rejet et validation        |
            | Toutes validation et rejet  | Liste - Validation - Toutes validation et rejet       |

    @x-wip @ignore
    Scenario Outline: ${action} avec métadonnées sur le dossier "${folder}" par ecapucine
        * def params =
"""
{
    tenant: "Métadonnées",
    annotation: "visa",
    username: "ecapucine",
    desktop: "Capucine",
    folder: "#(folder)",
    metadata: "#(map['<folder>'])"
}
"""
        * configure driver = ui.driver.configure
        * driver baseUrl + ui.url.logout
        * ui.user.login(params.username, 'a123456')

        * click("{a}" + params.desktop)

        # Filtre sur le nom du dossier
        # @todo: ui.xxx.filter.toggle, ui.xxx.filter.apply
        * click("//ngb-pagination/parent::div//button//span[text()='Filtrer']")
        * input(ui.locator.input('Titre'), '<folder>')
        * click("//app-folder-filter-panel//button//span[text()='Filtrer']")

        * click("{a}<folder>")

        * waitFor(ui.element.breadcrumb("Accueil / " + params.tenant + " / " + params.desktop + " / " + params.folder))

        * click("//button[contains(normalize-space(text()), '" + action + "')]")

        * ui.folder.annotate.both(params.username, action, params.folder)

        # @todo: métadonnées
        * def metadatas = map['<folder>']
        * def fillMetadatas =
"""
function(metadatas) {
    var field, key, xpath;
    for (key in metadatas) {
        xpath = "//app-metadata-form//label[normalize-space(text())='" + fields[key] + "']/parent::div/app-metadata-input";
        karate.log({key: key, text: fields[key]});
        // @todo: faire quelque chose avec les ng-select
    }
}
"""
        * karate.log(metadatas)
        * fillMetadatas(metadatas)

        * click("{^}Valider")
        * waitFor(ui.element.breadcrumb("Accueil / Bureaux"))
        * waitFor(ui.toast.success("action " + action + " sur le dossier " + folder + " a été effectuée avec succès"))

        Examples:
            | folder                                               | action |
            | Individuel - Validation - Toutes validation et rejet | Visa   |
@x-wip
    # @todo: via UI
    Scenario Outline: Traitement du dossier "${folder}" par ecapucine
        * def params =
"""
{
    tenant: "Métadonnées",
    annotation: "visa",
    username: "ecapucine",
    desktop: "Capucine",
    folder: "#(folder)",
    metadata: "#(map['<folder>'])"
}
"""
        * api_v1.auth.login(params.username, 'a123456')
        * call read("classpath:lib/v5/business/api/folder/<action>.feature") params

        Examples:
            | folder                                                | action |
            | Individuel - Rejet - Aucune métadonnée                | reject |
            | Individuel - Rejet - Booleen rejet                    | reject |
            | Individuel - Rejet - Booleen validation               | reject |
            | Individuel - Rejet - Booleen rejet et validation      | reject |
            | Individuel - Rejet - Texte rejet                      | reject |
            | Individuel - Rejet - Texte validation                 | reject |
            | Individuel - Rejet - Texte rejet et validation        | reject |
            | Individuel - Rejet - Toutes validation et rejet       | reject |
            | Individuel - Validation - Aucune métadonnée           | visa   |
            | Individuel - Validation - Booleen rejet               | visa   |
            | Individuel - Validation - Booleen validation          | visa   |
            | Individuel - Validation - Booleen rejet et validation | visa   |
            | Individuel - Validation - Texte rejet                 | visa   |
            | Individuel - Validation - Texte validation            | visa   |
            | Individuel - Validation - Texte rejet et validation   | visa   |
            | Individuel - Validation - Toutes validation et rejet  | visa   |

    # @todo: via API + UI
    @ignore
    Scenario Outline: Vérification des métadonnées du dossier "${folder}" par ws-meta
        * def params =
"""
{
    tenant: "Métadonnées",
    username: "ws-meta",
    desktop: "WebService",
    folder: "#(folder)"
}
"""
        * api_v1.auth.login(params.username, 'a123456')
        * def tenant = v5.business.api.tenant.getByName(params.tenant)
        * def desktop = v5.business.api.desktop.getByName(tenant.id, params.desktop)
        * def folder = v5.business.api.folder.getByName(tenant.id, desktop.id, "<state>", params.folder)

        * def internal =
"""
{
    "workflow_internal_final_group_id": "#uuid",
    "workflow_internal_steps": "#present",
    "i_Parapheur_internal_emitter_id": "#uuid",
    "workflow_internal_validation_workflow_id": "#string"
}
"""
        * def valuesToString =
"""
function (dict) {
    var key;
    for (key in dict) {
        switch(typeof dict[key]) {
            case "boolean":
                if (dict[key] === true) {
                    dict[key] = "true";
                }
                else if (dict[key] === false) {
                    dict[key] = "false";
                }
                break;
            case "number":
                dict[key] = String(dict[key]);
                break;
        }
    }
    return dict;
}
"""
        * def expected = karate.merge(internal, valuesToString(map['<folder>']))
        * match folder.metadata == expected

        Examples:
            | folder                                                | state    |
            | Individuel - Rejet - Aucune métadonnée                | rejected |
            | Individuel - Rejet - Booleen rejet                    | rejected |
            | Individuel - Rejet - Booleen validation               | rejected |
            | Individuel - Rejet - Booleen rejet et validation      | rejected |
            | Individuel - Rejet - Texte rejet                      | rejected |
            | Individuel - Rejet - Texte validation                 | rejected |
            | Individuel - Rejet - Texte rejet et validation        | rejected |
            | Individuel - Rejet - Toutes validation et rejet       | rejected |
            | Individuel - Validation - Aucune métadonnée           | finished |
            | Individuel - Validation - Booleen rejet               | finished |
            | Individuel - Validation - Booleen validation          | finished |
            | Individuel - Validation - Booleen rejet et validation | finished |
            | Individuel - Validation - Texte rejet                 | finished |
            | Individuel - Validation - Texte validation            | finished |
            | Individuel - Validation - Texte rejet et validation   | finished |
            | Individuel - Validation - Toutes validation et rejet  | finished |

    @wip @x-ignore
    Scenario Outline: Vérification des métadonnées sur le dossier "${folder}" par ws-meta
        * def params =
"""
{
    tenant: "Métadonnées",
    username: "ws-meta",
    desktop: "WebService",
    folder: "#(folder)"
}
"""
        * configure driver = ui.driver.configure
        * driver baseUrl + ui.url.logout
        * ui.user.login(params.username, 'a123456')

        * click("{a}" + params.desktop)
        * click("//span[contains(@class, 'badge badge-<state> desk-badge')]")

        # Filtre sur le nom du dossier
        # @todo: ui.xxx.filter.toggle, ui.xxx.filter.apply
        * click("//ngb-pagination/parent::div//button//span[text()='Filtrer']")
        * input(ui.locator.input('Titre'), '<folder>')
        * click("//app-folder-filter-panel//button//span[text()='Filtrer']")

        * click("{a}<folder>")

        * waitFor(ui.element.breadcrumb("Accueil / " + params.tenant + " / " + params.desktop + " / " + params.folder))

        # @todo: métadonnées
#        * def metadatas = map['<folder>']
        * def getMetadatas =
"""
function() {
    var actual = {},
        content,
        idx,
        inputs,
        label,
        lines,
        row,
        inputType,
        xpath = "//strong[text()='Métadonnées']/parent::div/parent::div/parent::div//app-step-metadata-list/div",
        xpathInput;
        //xpath = "//strong[text()='Métadonnées']/parent::div/parent::div/parent::div//app-metadata-input";

    inputs = locateAll(xpath);
    lines = karate.sizeOf(inputs);
    //karate.log(inputs);

    for (idx = 1;idx <= lines;idx++) {
        label = text(xpath + "[position() = " + idx + "]/label").trim();
        //karate.log(inverse[label]);

        content = null;
        if (exists(xpath + "[position() = " + idx + "]/app-metadata-input//ng-select") === true) {
            xpathInput = xpath + "[position() = " + idx + "]/app-metadata-input//ng-select";
            //script("(document.evaluate(\"" + xpathInput + "\", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue).disabled = false");
            //karate.log(xpathInput);
            //karate.log(JSON.stringify(value(xpathInput)));
            //content = value(xpathInput);//@todo: si date, etc... -> reformater
            content = text(xpathInput + "//span[contains(@class, 'ng-value-label')]").trim();//@fixme: la valeur ? ou reformater ?

            inputType = types[inverse[label]];
            //karate.log(inputType);
            if (inputType === "BOOLEAN") {
                if (content === "Oui") {
                    content = true;
                } else if (content === "Non") {
                    content = false;
                }
            } else if (inputType === "DATE") {
                content = content.replace(/^(..)\/(..)\/(....)$/, "$3-$2-$1");
            } else if (inputType === "FLOAT") {
                content = parseFloat(content);
            } else if (inputType === "INTEGER") {
                content = parseInt(content, 10);
            }
        } else if (exists(xpath + "[position() = " + idx + "]/app-metadata-input//input") === true) {
            xpathInput = xpath + "[position() = " + idx + "]/app-metadata-input//input";
            content = value(xpathInput).trim();
            inputType = types[inverse[label]];
            //karate.log(inputType);
            if (inputType === "FLOAT") {
                content = parseFloat(content);
            } else if (inputType === "INTEGER") {
                content = parseInt(content, 10);
            }
            /*script("(document.evaluate(\"" + xpathInput + "\", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue).disabled = false");
            input = locate(xpathInput);
            karate.log(input);
            karate.log(html(xpathInput));
            karate.log(value(xpathInput));*/
        } else {
            // @todo: fail
        }

        actual[inverse[label]] = content;
    }

    //------------------------------------------

    //karate.doc(html(inputs[0]));
    //karate.log(inputs[0].html());

    /*
    //waitFor("//strong[text()='Annotations publiques']/ancestor::div[@class='mt-3 ng-star-inserted']");
    lines = karate.sizeOf(locateAll(xpath));
    //karate.log(xpath);
    //karate.log(locateAll(xpath));
    //karate.log(lines);

    for (idx = 1;idx <= lines;idx++) {
        karate.log(idx);
        var foo = "(" + xpath +")[" + idx + "]";
        karate.log(foo);

        // Label
        label = text("(" + foo + "/parent::div//label)").trim();
        karate.log(inverse[label]);

        // Valeur - liste de sélection
        //value = text(xpath + "[position() = " + idx + "]//span[contains(@class, 'ng-value-label')]").trim();
        // @todo: traduire la valeur... (Oui -> true, ...)
        //karate.log(value);

        actual[inverse[label]] = value;
    }*/
    return actual;
}
"""
    #* karate.log(metadatas)
#    * pause(5)
      * waitFor("//strong[text()='Métadonnées']");
      * def metadatas = getMetadatas()
      * karate.log(metadatas)
      * match metadatas == map['<folder>']

      Examples:
          | folder                                               | state      |
          | Individuel - Validation - Toutes validation et rejet | finished   |
