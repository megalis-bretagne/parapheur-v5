@business @metadonnees @folder-checks @proposal
Feature: Vérifications de dossiers pour le paramétrage métier "Métadonnées"

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
        * match rv.metadatas == ip.metadatas.map['<folder>']

        Examples:
            | folder                                                | state    |
            | Groupe - Rejet - Aucune métadonnée                    | rejected |
            | Groupe - Rejet - Booleen rejet                        | rejected |
            | Groupe - Rejet - Booleen validation                   | rejected |
            | Groupe - Rejet - Booleen rejet et validation          | rejected |
            | Groupe - Rejet - Texte rejet                          | rejected |
            | Groupe - Rejet - Texte validation                     | rejected |
            | Groupe - Rejet - Texte rejet et validation            | rejected |
            | Groupe - Rejet - Toutes validation et rejet           | rejected |
            | Groupe - Validation - Aucune métadonnée               | finished |
            | Groupe - Validation - Booleen rejet                   | finished |
            | Groupe - Validation - Booleen validation              | finished |
            | Groupe - Validation - Booleen rejet et validation     | finished |
            | Groupe - Validation - Texte rejet                     | finished |
            | Groupe - Validation - Texte validation                | finished |
            | Groupe - Validation - Texte rejet et validation       | finished |
            | Groupe - Validation - Toutes validation et rejet      | finished |
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
            | Liste - Rejet - Aucune métadonnée                     | rejected |
            | Liste - Rejet - Booleen rejet                         | rejected |
            | Liste - Rejet - Booleen validation                    | rejected |
            | Liste - Rejet - Booleen rejet et validation           | rejected |
            | Liste - Rejet - Texte rejet                           | rejected |
            | Liste - Rejet - Texte validation                      | rejected |
            | Liste - Rejet - Texte rejet et validation             | rejected |
            | Liste - Rejet - Toutes validation et rejet            | rejected |
            | Liste - Validation - Aucune métadonnée                | finished |
            | Liste - Validation - Booleen rejet                    | finished |
            | Liste - Validation - Booleen validation               | finished |
            | Liste - Validation - Booleen rejet et validation      | finished |
            | Liste - Validation - Texte rejet                      | finished |
            | Liste - Validation - Texte validation                 | finished |
            | Liste - Validation - Texte rejet et validation        | finished |
            | Liste - Validation - Toutes validation et rejet       | finished |
