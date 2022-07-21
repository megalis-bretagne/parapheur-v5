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
        | Aucune métadonnée           | Groupe - Rejet - Aucune métadonnée                    | création et démarrage depuis karate |
        | Booleen rejet               | Groupe - Rejet - Booleen rejet                        | création et démarrage depuis karate |
        | Booleen validation          | Groupe - Rejet - Booleen validation                   | création et démarrage depuis karate |
        | Booleen rejet et validation | Groupe - Rejet - Booleen rejet et validation          | création et démarrage depuis karate |
        | Texte rejet                 | Groupe - Rejet - Texte rejet                          | création et démarrage depuis karate |
        | Texte validation            | Groupe - Rejet - Texte validation                     | création et démarrage depuis karate |
        | Texte rejet et validation   | Groupe - Rejet - Texte rejet et validation            | création et démarrage depuis karate |
#        | Toutes validation et rejet  | Groupe - Rejet - Toutes validation et rejet           |
        | Aucune métadonnée           | Groupe - Validation - Aucune métadonnée               | création et démarrage depuis karate |
        | Booleen rejet               | Groupe - Validation - Booleen rejet                   | création et démarrage depuis karate |
        | Booleen validation          | Groupe - Validation - Booleen validation              | création et démarrage depuis karate |
        | Booleen rejet et validation | Groupe - Validation - Booleen rejet et validation     | création et démarrage depuis karate |
        | Texte rejet                 | Groupe - Validation - Texte rejet                     | création et démarrage depuis karate |
        | Texte validation            | Groupe - Validation - Texte validation                | création et démarrage depuis karate |
        | Texte rejet et validation   | Groupe - Validation - Texte rejet et validation       | création et démarrage depuis karate |
#        | Toutes validation et rejet  | Groupe - Validation - Toutes validation et rejet      | création et démarrage depuis karate |
        | Aucune métadonnée           | Individuel - Rejet - Aucune métadonnée                | création et démarrage depuis karate |
        | Booleen rejet               | Individuel - Rejet - Booleen rejet                    | création et démarrage depuis karate |
        | Booleen validation          | Individuel - Rejet - Booleen validation               | création et démarrage depuis karate |
        | Booleen rejet et validation | Individuel - Rejet - Booleen rejet et validation      | création et démarrage depuis karate |
        | Texte rejet                 | Individuel - Rejet - Texte rejet                      | création et démarrage depuis karate |
        | Texte validation            | Individuel - Rejet - Texte validation                 | création et démarrage depuis karate |
        | Texte rejet et validation   | Individuel - Rejet - Texte rejet et validation        | création et démarrage depuis karate |
        | Toutes validation et rejet  | Individuel - Rejet - Toutes validation et rejet       | création et démarrage depuis karate |
        | Aucune métadonnée           | Individuel - Validation - Aucune métadonnée           | création et démarrage depuis karate |
        | Booleen rejet               | Individuel - Validation - Booleen rejet               | création et démarrage depuis karate |
        | Booleen validation          | Individuel - Validation - Booleen validation          | création et démarrage depuis karate |
        | Booleen rejet et validation | Individuel - Validation - Booleen rejet et validation | création et démarrage depuis karate |
        | Texte rejet                 | Individuel - Validation - Texte rejet                 | création et démarrage depuis karate |
        | Texte validation            | Individuel - Validation - Texte validation            | création et démarrage depuis karate |
        | Texte rejet et validation   | Individuel - Validation - Texte rejet et validation   | création et démarrage depuis karate |
        | Toutes validation et rejet  | Individuel - Validation - Toutes validation et rejet  | création et démarrage depuis karate |
        | Aucune métadonnée           | Liste - Rejet - Aucune métadonnée                     | création et démarrage depuis karate |
        | Booleen rejet               | Liste - Rejet - Booleen rejet                         | création et démarrage depuis karate |
        | Booleen validation          | Liste - Rejet - Booleen validation                    | création et démarrage depuis karate |
        | Booleen rejet et validation | Liste - Rejet - Booleen rejet et validation           | création et démarrage depuis karate |
        | Texte rejet                 | Liste - Rejet - Texte rejet                           | création et démarrage depuis karate |
        | Texte validation            | Liste - Rejet - Texte validation                      | création et démarrage depuis karate |
        | Texte rejet et validation   | Liste - Rejet - Texte rejet et validation             | création et démarrage depuis karate |
        | Toutes validation et rejet  | Liste - Rejet - Toutes validation et rejet            | création et démarrage depuis karate |
        | Aucune métadonnée           | Liste - Validation - Aucune métadonnée                | création et démarrage depuis karate |
        | Booleen rejet               | Liste - Validation - Booleen rejet                    | création et démarrage depuis karate |
        | Booleen validation          | Liste - Validation - Booleen validation               | création et démarrage depuis karate |
        | Booleen rejet et validation | Liste - Validation - Booleen rejet et validation      | création et démarrage depuis karate |
        | Texte rejet                 | Liste - Validation - Texte rejet                      | création et démarrage depuis karate |
        | Texte validation            | Liste - Validation - Texte validation                 | création et démarrage depuis karate |
        | Texte rejet et validation   | Liste - Validation - Texte rejet et validation        | création et démarrage depuis karate |
        | Toutes validation et rejet  | Liste - Validation - Toutes validation et rejet       | création et démarrage depuis karate |

