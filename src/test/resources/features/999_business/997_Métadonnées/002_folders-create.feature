@business @metadonnees @folders-create
Feature: Création de dossiers pour le paramétrage métier "Métadonnées"

    Scenario Outline: Create one "${mode} - ${action} - ${subtype}" folder
        * call read("classpath:lib/v5/business/Métadonnées/folder/single.create.feature") __row

        Examples:
            | mode       | action | subtype               |
            | Groupe     | Rejet  | Aucune métadonnée     |
            | Groupe     | Rejet  | Booleen rejet         |
            | Groupe     | Rejet  | Booleen visa          |
            | Groupe     | Rejet  | Booleen rejet et visa |
            | Groupe     | Rejet  | Texte rejet           |
            | Groupe     | Rejet  | Texte visa            |
            | Groupe     | Rejet  | Texte rejet et visa   |
            | Groupe     | Rejet  | Toutes visa et rejet  |
            | Groupe     | Visa   | Aucune métadonnée     |
            | Groupe     | Visa   | Booleen rejet         |
            | Groupe     | Visa   | Booleen visa          |
            | Groupe     | Visa   | Booleen rejet et visa |
            | Groupe     | Visa   | Texte rejet           |
            | Groupe     | Visa   | Texte visa            |
            | Groupe     | Visa   | Texte rejet et visa   |
            | Groupe     | Visa   | Toutes visa et rejet  |
            | Individuel | Rejet  | Aucune métadonnée     |
            | Individuel | Rejet  | Booleen rejet         |
            | Individuel | Rejet  | Booleen visa          |
            | Individuel | Rejet  | Booleen rejet et visa |
            | Individuel | Rejet  | Texte rejet           |
            | Individuel | Rejet  | Texte visa            |
            | Individuel | Rejet  | Texte rejet et visa   |
            | Individuel | Rejet  | Toutes visa et rejet  |
            | Individuel | Visa   | Aucune métadonnée     |
            | Individuel | Visa   | Booleen rejet         |
            | Individuel | Visa   | Booleen visa          |
            | Individuel | Visa   | Booleen rejet et visa |
            | Individuel | Visa   | Texte rejet           |
            | Individuel | Visa   | Texte visa            |
            | Individuel | Visa   | Texte rejet et visa   |
            | Individuel | Visa   | Toutes visa et rejet  |
            | Liste      | Rejet  | Aucune métadonnée     |
            | Liste      | Rejet  | Booleen rejet         |
            | Liste      | Rejet  | Booleen visa          |
            | Liste      | Rejet  | Booleen rejet et visa |
            | Liste      | Rejet  | Texte rejet           |
            | Liste      | Rejet  | Texte visa            |
            | Liste      | Rejet  | Texte rejet et visa   |
            | Liste      | Rejet  | Toutes visa et rejet  |
            | Liste      | Visa   | Aucune métadonnée     |
            | Liste      | Visa   | Booleen rejet         |
            | Liste      | Visa   | Booleen visa          |
            | Liste      | Visa   | Booleen rejet et visa |
            | Liste      | Visa   | Texte rejet           |
            | Liste      | Visa   | Texte visa            |
            | Liste      | Visa   | Texte rejet et visa   |
            | Liste      | Visa   | Toutes visa et rejet  |
