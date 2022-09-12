@business @ip5 @metadonnees @folders-process
Feature: Traitement de dossiers pour le paramétrage métier "Métadonnées"

    Scenario Outline: Traitement du dossier "Individuel - ${action} - ${subtype}" en individuel via UI par ecapucine
    * def defaults =
"""
{
    type: "PAdES",
    folder: "Individuel - <action> - <subtype>"
}
"""
        * call read("classpath:lib/v5/business/Métadonnées/folder/single.process.feature") karate.merge(defaults, __row)

        Examples:
            | action | subtype               |
            | Rejet  | Aucune métadonnée     |
            | Rejet  | Booleen rejet         |
            | Rejet  | Booleen visa          |
            | Rejet  | Booleen rejet et visa |
            | Rejet  | Texte rejet           |
            | Rejet  | Texte visa            |
            | Rejet  | Texte rejet et visa   |
            | Rejet  | Toutes visa et rejet  |
            | Visa   | Aucune métadonnée     |
            | Visa   | Booleen rejet         |
            | Visa   | Booleen rejet et visa |
            | Visa   | Booleen visa          |
            | Visa   | Texte rejet           |
            | Visa   | Texte visa            |
            | Visa   | Texte rejet et visa   |
            | Visa   | Toutes visa et rejet  |

    Scenario Outline: Traitement du dossier "Liste - ${action} - ${subtype}" en liste via UI par ecapucine
        * def defaults =
"""
{
    type: "PAdES",
    folder: "Liste - <action> - <subtype>"
}
"""
        * call read("classpath:lib/v5/business/Métadonnées/folder/list.process.feature") karate.merge(defaults, __row)

        Examples:
            | action | subtype           |
            | Rejet  | Aucune métadonnée |
            | Rejet  | Booleen visa      |
            | Rejet  | Texte visa        |
            | Visa   | Aucune métadonnée |
            | Visa   | Booleen rejet     |
            | Visa   | Texte rejet       |

    @fixme-ip5
    Scenario Outline: FIXME - Traitement du dossier "Liste - ${action} - ${subtype}" en liste via UI par ecapucine
        * def defaults =
"""
{
    type: "PAdES",
    folder: "Liste - <action> - <subtype>"
}
"""
        * call read("classpath:lib/v5/business/Métadonnées/folder/list.process.feature") karate.merge(defaults, __row)

        Examples:
            | action | subtype               |
            | Rejet  | Booleen rejet         |
            | Rejet  | Booleen rejet et visa |
            | Rejet  | Texte rejet           |
            | Rejet  | Texte rejet et visa   |
            | Rejet  | Toutes visa et rejet  |
            | Visa   | Booleen visa          |
            | Visa   | Booleen rejet et visa |
            | Visa   | Texte visa            |
            | Visa   | Texte rejet et visa   |
            | Visa   | Toutes visa et rejet  |

    @fixme-ip5
    Scenario Outline: Traitement des dossiers "${folder}" en groupe via UI par ecapucine
        * call read("classpath:lib/v5/business/Métadonnées/folder/group.process.feature") __row

        Examples:
            | action | folder         |
            | Rejet  | Groupe - Rejet |
            | Visa   | Groupe - Visa  |
