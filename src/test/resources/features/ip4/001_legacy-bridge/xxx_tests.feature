@proposal @ignore @ip4
Feature: Tests IP 4

    Scenario Outline: Création du dossier "${title}" de type "${type} / ${subtype}" par "${username}" sur le bureau "${desktop}"
        * v4.api.rest.user.login(username, password)
        * call read('classpath:lib/v4/api/rest/folder/create.feature') __row

        Examples:
            | username         | password | desktop    | type          | subtype        | title | files!                                                                                                                 | metadatas! | annotation                          |
            | ws@legacy-bridge | a123456  | WebService | Auto monodoc  | sign sans meta | aaa   | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf']                                                            | {}         | création et démarrage depuis karate |
            | ws@legacy-bridge | a123456  | WebService | Auto multidoc | sign sans meta | bbb   | ['classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf', 'classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | {}         | création et démarrage depuis karate |
    # @todo: inclure des signatures dans IP 5 puis revoir les tests du legacy-bridge
    Scenario Outline: Signature du dossier "${folder}" par "${username}"
        * v4.api.rest.user.login(username, password)
        * call read('classpath:lib/v4/api/rest/folder/sign.feature') __row

        Examples:
            | username                 | password | desktop   | folder | certificate | annotation              |
            | lvermillon@legacy-bridge | a123456  | Vermillon | aaa    | signature   | signature depuis karate |
            | lvermillon@legacy-bridge | a123456  | Vermillon | bbb    | signature   | signature depuis karate |

    # ----------------------------------------------------------------------------------------------------------------------------------------------------------

    @x-wip
    # @todo: view
    # @info: liste complète et correcte src/test/resources/features/ip4/001_legacy-bridge/002_folders.feature
    # @info: metadonnées lors des actions autres que la signature
    Scenario Outline: Création du dossier "${title}" de type "${type} / ${subtype}" par "${username}" sur le bureau "${desktop}"
        * v4.api.rest.user.login(username, password)
        * call read('classpath:lib/v4/api/rest/folder/create.feature') __row

        Examples:
            | username         | password | desktop    | type         | subtype        | title                    | files!                                                      | metadatas!               | annotation                          |
            | ws@legacy-bridge | a123456  | WebService | Auto monodoc | sign avec meta | XXXAuto_sign_avec_meta_1 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } | création et démarrage depuis karate |
            | ws@legacy-bridge | a123456  | WebService | Auto monodoc | sign avec meta | XXXAuto_sign_avec_meta_1 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } | création et démarrage depuis karate |
            | ws@legacy-bridge | a123456  | WebService | Auto monodoc | visa avec meta | XXXAuto_visa_avec_meta_1 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } | création et démarrage depuis karate |
            | ws@legacy-bridge | a123456  | WebService | Auto monodoc | visa avec meta | XXXAuto_visa_avec_meta_2 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } | création et démarrage depuis karate |
            | ws@legacy-bridge | a123456  | WebService | Auto monodoc | visa avec meta | XXXAuto_visa_avec_meta_3 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } | création et démarrage depuis karate |
            | ws@legacy-bridge | a123456  | WebService | Auto monodoc | visa avec meta | XXXAuto_visa_avec_meta_4 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } | création et démarrage depuis karate |
            | ws@legacy-bridge | a123456  | WebService | PAdES        | cachet         | XXXPAdES_cachet_1        | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | {}                       | création et démarrage depuis karate |
            | ws@legacy-bridge | a123456  | WebService | PAdES        | cachet         | XXXPAdES_cachet_2        | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | {}                       | création et démarrage depuis karate |
            | ws@legacy-bridge | a123456  | WebService | PAdES        | mailsec        | XXXPAdES_mailsec_1       | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | {}                       | création et démarrage depuis karate |
            | ws@legacy-bridge | a123456  | WebService | PAdES        | mailsec        | XXXPAdES_mailsec_2       | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | {}                       | création et démarrage depuis karate |

    @x-wip
    # @fixme: le mail sécurisé n'est pas envoyé sur https://iparapheur47.test.libriciel.fr
    # Erreur sur le dossier XXXPAdES_mailsec_1 : Exception lors du traitement du dossier : JSONObject["id"] not found.
    Scenario Outline: Mail sécurisé sur le dossier "${folder}" par "${username}"
        * v4.api.rest.user.login(username, password)
        * call read('classpath:lib/v4/api/rest/folder/mailsecSend.feature') __row

        Examples:
            | username                 | password | desktop   | folder             | to!                                 |
            | lvermillon@legacy-bridge | a123456  | Vermillon | XXXPAdES_mailsec_1 | ["christian.buffin@libriciel.coop"] |

    @x-wip
    Scenario Outline: Cachet sur le dossier "${folder}" par "${username}"
        * v4.api.rest.user.login(username, password)
        * call read('classpath:lib/v4/api/rest/folder/seal.feature') __row

        Examples:
            | username                 | password | desktop   | folder            | annotation           |
            | lvermillon@legacy-bridge | a123456  | Vermillon | XXXPAdES_cachet_1 | cachet depuis karate |

    @x-wip
    Scenario Outline: Visa sur le dossier "${folder}" par "${username}"
        * v4.api.rest.user.login(username, password)
        * call read('classpath:lib/v4/api/rest/folder/visa.feature') __row

        Examples:
            | username                 | password | desktop   | folder                   | annotation         |
            | lvermillon@legacy-bridge | a123456  | Vermillon | XXXAuto_visa_avec_meta_1 | visa depuis karate |
            | lvermillon@legacy-bridge | a123456  | Vermillon | XXXAuto_visa_avec_meta_3 | visa depuis karate |

    @x-wip
    Scenario Outline: Rejet du dossier "${folder}" par "${username}"
        * v4.api.rest.user.login(username, password)
        * call read('classpath:lib/v4/api/rest/folder/reject.feature') __row

        Examples:
            | username                 | password | desktop   | folder                   | annotation          |
            | lvermillon@legacy-bridge | a123456  | Vermillon | XXXAuto_sign_avec_meta_1 | rejet depuis karate |
            | lvermillon@legacy-bridge | a123456  | Vermillon | XXXAuto_visa_avec_meta_2 | rejet depuis karate |
            | lvermillon@legacy-bridge | a123456  | Vermillon | XXXAuto_visa_avec_meta_4 | rejet depuis karate |
            | lvermillon@legacy-bridge | a123456  | Vermillon | XXXPAdES_cachet_2        | rejet depuis karate |
            | lvermillon@legacy-bridge | a123456  | Vermillon | XXXPAdES_mailsec_2       | rejet depuis karate |
