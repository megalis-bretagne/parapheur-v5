@proposal @ignore @ip4
Feature: Tests IP 4

    Scenario Outline: Création du dossier "${title}" de type "${type} / ${subtype}" par "${username}" sur le bureau "${desktop}"
        * v4.api.rest.user.login(username, password)
        * call read('classpath:lib/v4/api/rest/folder/create.feature') __row

        Examples:
            | username         | password | desktop    | type          | subtype        | title | files!                                                                                                                 | metadatas! | annotation                          |
            | ws@legacy-bridge | a123456  | WebService | Auto monodoc  | sign sans meta | aaa   | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf']                                                            | {}         | création et démarrage depuis karate |
            | ws@legacy-bridge | a123456  | WebService | Auto multidoc | sign sans meta | bbb   | ['classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf', 'classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | {}         | création et démarrage depuis karate |

    Scenario Outline: Signature du dossier "${folder}" par "${username}"
        * v4.api.rest.user.login(username, password)
        * call read('classpath:lib/v4/api/rest/folder/sign.feature') __row

        Examples:
            | username                 | password | desktop   | folder | certificate | annotation              |
            | lvermillon@legacy-bridge | a123456  | Vermillon | aaa    | signature   | signature depuis karate |
            | lvermillon@legacy-bridge | a123456  | Vermillon | bbb    | signature   | signature depuis karate |
