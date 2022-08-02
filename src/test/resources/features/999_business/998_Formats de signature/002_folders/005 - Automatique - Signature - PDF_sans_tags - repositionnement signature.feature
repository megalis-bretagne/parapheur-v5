@business @formats-de-signature @folder
Feature: Automatique - Signature - PDF_sans_tags - repositionnement signature

    Background:
        * def type = "Automatique"
        * def subtype = "Signature"
        * def name = "Automatique - Signature - PDF_sans_tags - repositionnement signature"
        * def files = [ { file: "PDF_sans_tags.pdf" } ]
        * def positions = { "PDF_sans_tags.pdf": {"signatureNumber":0,"page":"1","x":200,"y":700} }

    Scenario: Création des dossiers
        * v5.business.formatsDeSignature.sign(type, subtype, name, files, positions)

    Scenario Outline: Vérifications de la liste des documents (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * match download.files == [ "PDF_sans_tags.pdf" ]

        Examples:
            | details        | key       |
            | sans surcharge | normal    |
            | avec surcharge | surcharge |

    Scenario Outline: Vérifications des signatures électroniques (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * def expected =
"""
[
    {
        "commonName": "Prenom Nom - Usages",
        "distinguishedName": "E=christian.buffin@libriciel.coop,CN=Prenom Nom - Usages,OU=Usages,O=Collectivite ou organisation,L=Ville,ST=34 - Herault,C=FR",
        "algorithm": "SHA-256",
        "type": "ETSI.CAdES.detached",
        "wholeDocumentSigned": true,
        "valid": true
    }
]
"""
        * match utils.signature.pdf.get(download.base + "/PDF_sans_tags.pdf") == expected

        Examples:
            | details        | key       |
            | sans surcharge | normal    |
            | avec surcharge | surcharge |

    @fixme-ip
    Scenario Outline: Vérifications des propriétés des signatures (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * def expected =
"""
[
    {
        "signedBy": "<signedBy>",
        "reason": "<reason>",
        "location": "<location>"
    }
]
"""
        * match utils.signature.pdf.getFields(download.base + "/PDF_sans_tags.pdf") == expected

        Examples:
            | details        | key       | signedBy            | reason                    | location    |
            | sans surcharge | normal    | Prenom Nom - Usages | Nacarat                   | Montpellier |
            | avec surcharge | surcharge | Prenom Nom - Usages | Responsable des méthodes  | Agde        |
