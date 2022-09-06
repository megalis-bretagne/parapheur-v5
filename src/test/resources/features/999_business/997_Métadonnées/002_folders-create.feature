@business @metadonnees @folder-create @proposal
Feature: Création de dossiers pour le paramétrage métier "Métadonnées"

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
