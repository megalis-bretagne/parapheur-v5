@legacy-bridge @folder @ip4
Feature: Création de dossiers pour le paramétrage métier "Legacy Bridge"

    Scenario Outline: Création du dossier "${title}" de type "${type} / ${subtype}" par "${username}" sur le bureau "${desktop}"
        * v4.business.api.user.login(username, password)

        * __row["annotation"] = "démarrage du dossier <title>"
        * call read('classpath:lib/v4/business/api/folder/create.feature') __row

    Examples:
        | username         | password | desktop    | type         | subtype        | title                 | files!                                                      | metadatas!               |
        | ws@legacy-bridge | a123456  | WebService | Auto monodoc | sign avec meta | Auto_sign_avec_meta_1 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } |
        | ws@legacy-bridge | a123456  | WebService | Auto monodoc | sign avec meta | Auto_sign_avec_meta_2 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } |
        | ws@legacy-bridge | a123456  | WebService | Auto monodoc | visa avec meta | Auto_visa_avec_meta_1 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } |
        | ws@legacy-bridge | a123456  | WebService | Auto monodoc | visa avec meta | Auto_visa_avec_meta_2 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } |
        | ws@legacy-bridge | a123456  | WebService | Auto monodoc | visa avec meta | Auto_visa_avec_meta_3 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } |
        | ws@legacy-bridge | a123456  | WebService | Auto monodoc | visa avec meta | Auto_visa_avec_meta_4 | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | { mameta_bool: "false" } |
        | ws@legacy-bridge | a123456  | WebService | PAdES        | cachet         | PAdES_cachet_1        | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | {}                       |
        | ws@legacy-bridge | a123456  | WebService | PAdES        | cachet         | PAdES_cachet_2        | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | {}                       |
        | ws@legacy-bridge | a123456  | WebService | PAdES        | mailsec        | PAdES_mailsec_1       | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | {}                       |
        | ws@legacy-bridge | a123456  | WebService | PAdES        | mailsec        | PAdES_mailsec_2       | ['classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf'] | {}                       |
