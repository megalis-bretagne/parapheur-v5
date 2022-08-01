@business @formats-de-signature @folder @new-ok
Feature: Automatique - Signature - PDF_avec_tags

    Background:
        * def type = "Automatique"
        * def subtype = "Signature"
        * def name = "Automatique - Signature - PDF_avec_tags"
        * def files = [ { file: "PDF_avec_tags.pdf" } ]

    Scenario: Création des dossiers
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des documents (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * match download.files == [ "PDF_avec_tags.pdf" ]

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
        * match utils.signature.pdf.get(download.base + "/PDF_avec_tags.pdf") == expected

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
        * match utils.signature.pdf.getFields(download.base + "/PDF_avec_tags.pdf") == expected

        Examples:
            | details        | key       | signedBy            | reason                    | location    |
            | sans surcharge | normal    | Prenom Nom - Usages | Nacarat                   | Montpellier |
            | avec surcharge | surcharge | Prenom Nom - Usages | Responsable des méthodes  | Agde        |
