@legacy-bridge @folder @ip4
Feature: Création de dossiers pour le paramétrage métier "Legacy Bridge"
@x-wip
    Scenario Outline: Création du dossier "${title}" de type "${type}/${subtype}" par le bureau "WebService"
        * v4.api.rest.user.login("ws@legacy-bridge", "a123456")
        * def params =
"""
{
    desktop: "WebService",
    file: "#(file)",
    title: "#(title)",
    visibility: "confidentiel",
    type: "#(type)",
    sousType: "#(subtype)",
    annotPub: "Annotation publique ws@legacy-bridge (création et démarrage depuis karate)",
    annotPriv: "Annotation privée ws@legacy-bridge (création et démarrage depuis karate)",
    metadatas: #(metadatas)
}
"""
        * call read('classpath:lib/v4/api/rest/folder/createSimple.feature') params

        Examples:
            | type         | subtype        | file                                                    | title                 | metadatas!               |
            | Auto monodoc | sign avec meta | classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf | Auto_sign_avec_meta_1 | { mameta_bool: "false" } |
            | Auto monodoc | sign avec meta | classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf | Auto_sign_avec_meta_2 | { mameta_bool: "false" } |
            | Auto monodoc | visa avec meta | classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf | Auto_visa_avec_meta_1 | { mameta_bool: "false" } |
            | Auto monodoc | visa avec meta | classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf | Auto_visa_avec_meta_2 | { mameta_bool: "false" } |
            | Auto monodoc | visa avec meta | classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf | Auto_visa_avec_meta_3 | { mameta_bool: "false" } |
            | Auto monodoc | visa avec meta | classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf | Auto_visa_avec_meta_4 | { mameta_bool: "false" } |
            | PAdES        | cachet         | classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf | PAdES_cachet_1        | {}                       |
            | PAdES        | cachet         | classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf | PAdES_cachet_2        | {}                       |
            | PAdES        | mailsec        | classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf | PAdES_mailsec_1       | {}                       |
            | PAdES        | mailsec        | classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf | PAdES_mailsec_2       | {}                       |
