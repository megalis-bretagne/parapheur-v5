@legacy-bridge @folder @ip4
Feature: Création de dossiers pour le paramétrage métier "Legacy Bridge"

    Scenario Outline: Création du dossier "${title}" de type "${type} / ${subtype}" par "${username}" sur le bureau "${desktop}"
        * v4.api.rest.user.login(username, password)

        * call read('classpath:lib/v4/api/rest/folder/create.feature') __row

    Examples:
        | username         | password | desktop    | type         | subtype        | title                    | files!                                                      | metadatas!               | annotation                          |
        | ws@legacy-bridge | a123456  | WebService | Auto monodoc | sign avec meta | Auto_sign_avec_meta_1 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } | création et démarrage depuis karate |
        | ws@legacy-bridge | a123456  | WebService | Auto monodoc | sign avec meta | Auto_sign_avec_meta_2 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } | création et démarrage depuis karate |
        | ws@legacy-bridge | a123456  | WebService | Auto monodoc | visa avec meta | Auto_visa_avec_meta_1 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } | création et démarrage depuis karate |
        | ws@legacy-bridge | a123456  | WebService | Auto monodoc | visa avec meta | Auto_visa_avec_meta_2 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } | création et démarrage depuis karate |
        | ws@legacy-bridge | a123456  | WebService | Auto monodoc | visa avec meta | Auto_visa_avec_meta_3 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } | création et démarrage depuis karate |
        | ws@legacy-bridge | a123456  | WebService | Auto monodoc | visa avec meta | Auto_visa_avec_meta_4 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } | création et démarrage depuis karate |
        | ws@legacy-bridge | a123456  | WebService | PAdES        | cachet         | PAdES_cachet_1        | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | {}                       | création et démarrage depuis karate |
        | ws@legacy-bridge | a123456  | WebService | PAdES        | cachet         | PAdES_cachet_2        | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | {}                       | création et démarrage depuis karate |
        | ws@legacy-bridge | a123456  | WebService | PAdES        | mailsec        | PAdES_mailsec_1       | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | {}                       | création et démarrage depuis karate |
        | ws@legacy-bridge | a123456  | WebService | PAdES        | mailsec        | PAdES_mailsec_2       | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | {}                       | création et démarrage depuis karate |
