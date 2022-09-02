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

    Scenario Outline: Create 1 "${nameTemplate}" folder
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

    Scenario Outline: Traitement du dossier "${folder}" via UI par ecapucine
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
    var field, key, labelValue, optionXpath, xpath;
    for (key in metadatas) {
        xpath = "//app-metadata-form//label[normalize-space(text())='" + fields[key] + "']/parent::div/app-metadata-input";
        // Type de champ
        if (exists(xpath + "//ng-select") === true) {
            mouse().move(xpath + "//ng-select//*[@class='ng-arrow-wrapper']").click();
            labelValue = metadatas[key];
            if (types[key] === "BOOLEAN") {
                if (metadatas[key] === true) {
                    labelValue = "Oui";
                } else if (metadatas[key] === false) {
                    labelValue = "Non";
                }
            } else if (types[key] === "DATE") {
                labelValue = metadatas[key].replace(/^(....)-(..)-(..)$/, "$3/$2/$1");
            }
            optionXpath = xpath + "//ng-select//*[@role='option']//*[@class='ng-option-label'][text()='" + labelValue + "']";
            waitFor(optionXpath);
            mouse().move(optionXpath).click()
        } else if (exists(xpath + "//input[(@type='number' or @type='text' or @type='url') and not(@readonly)]") === true) {
            if (types[key] === "FLOAT" || types[key] === "INTEGER") {
                input(xpath + "//input", String(metadatas[key]));
            } else {
                input(xpath + "//input", metadatas[key]);
            }
        } else if (exists(xpath + "//input[(@type='date') and not(@readonly)]") === true) {
            input(xpath + "//input", metadatas[key].replace(/^(....)-(..)-(..)$/, "$3/$2/$1"));
        } else {
            karate.fail('Le champ renseigné n\'est pas pris en compte pour la clé "' + key + '" pour le xpath ' + xpath);
        }
        pause(5);
    }
}
"""
        * fillMetadatas(metadatas)

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

    Scenario Outline: Vérification des métadonnées sur le dossier "${folder}" par ws-meta (via UI)
        * def params =
"""
{
    tenant: "Métadonnées",
    username: "ws-meta",
    desktop: "WebService",
    folder: "#(folder)",
    state: "#(state)"
}
"""
        * def rv = call read("classpath:lib/v5/business/Métadonnées/getFolderMetadatasThroughUI.feature") params
        * match rv.metadatas == map['<folder>']

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
