@wip
Feature: Test signature IP 5

    Scenario Outline: Création du dossier "${nameTemplate}" de type type "${type} / ${subtype}"
        * api_v1.auth.login("user", "password")
        * def folders = api_v1.desk.draft.getPayloadMonodoc(__row, 1, {}, 1)
        * api_v1.auth.login("<username>", "<password>")
        * call read("classpath:lib/api/draft/create-and-send-monodoc-without-annex.feature") folders

        Examples:
            | tenant      | username       | password | desktop    | mainFile!                                                 | type  | subtype      | nameTemplate | annotation |
            | Démo simple | ws@demo-simple | a123456  | WebService | 'classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf' | ACTES | Délibération | xxx          | démarrage  |

    Scenario Outline: Signature du dossier "${folder}"
        * api_v1.auth.login("<username>", "<password>")

        * call read("classpath:lib/v5/business/api/folder/sign.feature") __row

        Examples:
            | tenant      | username               | password | desktop   | folder | certificate | annotation |
            | Démo simple | flosserand@demo-simple | a123456  | Président | xxx    | signature   | signature  |
