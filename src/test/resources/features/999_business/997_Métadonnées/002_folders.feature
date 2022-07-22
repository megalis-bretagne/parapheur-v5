@business @metadonnees @folder @proposal
Feature: Création de dossiers pour le paramétrage métier "Métadonnées"

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
    annotation: '<annotation>',
    username: '<username>',
}
"""
    * api_v1.auth.login('user', 'password')
    * def folders = api_v1.desk.draft.getPayloadMonodoc(params, 1, {}, 1)
    * api_v1.auth.login('ws-meta', 'a123456')
    * def result = call read('classpath:lib/api/draft/create-and-send-monodoc-without-annex.feature') folders

    Examples:
        | subtype                     | nameTemplate                                          | annotation                          |
        | Aucune métadonnée           | Groupe - Rejet - Aucune métadonnée                    | démarrage |
        | Booleen rejet               | Groupe - Rejet - Booleen rejet                        | démarrage |
        | Booleen validation          | Groupe - Rejet - Booleen validation                   | démarrage |
        | Booleen rejet et validation | Groupe - Rejet - Booleen rejet et validation          | démarrage |
        | Texte rejet                 | Groupe - Rejet - Texte rejet                          | démarrage |
        | Texte validation            | Groupe - Rejet - Texte validation                     | démarrage |
        | Texte rejet et validation   | Groupe - Rejet - Texte rejet et validation            | démarrage |
#        | Toutes validation et rejet  | Groupe - Rejet - Toutes validation et rejet           |
        | Aucune métadonnée           | Groupe - Validation - Aucune métadonnée               | démarrage |
        | Booleen rejet               | Groupe - Validation - Booleen rejet                   | démarrage |
        | Booleen validation          | Groupe - Validation - Booleen validation              | démarrage |
        | Booleen rejet et validation | Groupe - Validation - Booleen rejet et validation     | démarrage |
        | Texte rejet                 | Groupe - Validation - Texte rejet                     | démarrage |
        | Texte validation            | Groupe - Validation - Texte validation                | démarrage |
        | Texte rejet et validation   | Groupe - Validation - Texte rejet et validation       | démarrage |
#        | Toutes validation et rejet  | Groupe - Validation - Toutes validation et rejet      | démarrage |
        | Aucune métadonnée           | Individuel - Rejet - Aucune métadonnée                | démarrage |
        | Booleen rejet               | Individuel - Rejet - Booleen rejet                    | démarrage |
        | Booleen validation          | Individuel - Rejet - Booleen validation               | démarrage |
        | Booleen rejet et validation | Individuel - Rejet - Booleen rejet et validation      | démarrage |
        | Texte rejet                 | Individuel - Rejet - Texte rejet                      | démarrage |
        | Texte validation            | Individuel - Rejet - Texte validation                 | démarrage |
        | Texte rejet et validation   | Individuel - Rejet - Texte rejet et validation        | démarrage |
        | Toutes validation et rejet  | Individuel - Rejet - Toutes validation et rejet       | démarrage |
        | Aucune métadonnée           | Individuel - Validation - Aucune métadonnée           | démarrage |
        | Booleen rejet               | Individuel - Validation - Booleen rejet               | démarrage |
        | Booleen validation          | Individuel - Validation - Booleen validation          | démarrage |
        | Booleen rejet et validation | Individuel - Validation - Booleen rejet et validation | démarrage |
        | Texte rejet                 | Individuel - Validation - Texte rejet                 | démarrage |
        | Texte validation            | Individuel - Validation - Texte validation            | démarrage |
        | Texte rejet et validation   | Individuel - Validation - Texte rejet et validation   | démarrage |
        | Toutes validation et rejet  | Individuel - Validation - Toutes validation et rejet  | démarrage |
        | Aucune métadonnée           | Liste - Rejet - Aucune métadonnée                     | démarrage |
        | Booleen rejet               | Liste - Rejet - Booleen rejet                         | démarrage |
        | Booleen validation          | Liste - Rejet - Booleen validation                    | démarrage |
        | Booleen rejet et validation | Liste - Rejet - Booleen rejet et validation           | démarrage |
        | Texte rejet                 | Liste - Rejet - Texte rejet                           | démarrage |
        | Texte validation            | Liste - Rejet - Texte validation                      | démarrage |
        | Texte rejet et validation   | Liste - Rejet - Texte rejet et validation             | démarrage |
        | Toutes validation et rejet  | Liste - Rejet - Toutes validation et rejet            | démarrage |
        | Aucune métadonnée           | Liste - Validation - Aucune métadonnée                | démarrage |
        | Booleen rejet               | Liste - Validation - Booleen rejet                    | démarrage |
        | Booleen validation          | Liste - Validation - Booleen validation               | démarrage |
        | Booleen rejet et validation | Liste - Validation - Booleen rejet et validation      | démarrage |
        | Texte rejet                 | Liste - Validation - Texte rejet                      | démarrage |
        | Texte validation            | Liste - Validation - Texte validation                 | démarrage |
        | Texte rejet et validation   | Liste - Validation - Texte rejet et validation        | démarrage |
        | Toutes validation et rejet  | Liste - Validation - Toutes validation et rejet       | démarrage |

