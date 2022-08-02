@business @formats-de-signature @folder
Feature: PAdES - Cachet serveur - PDF_sans_tags - repositionnement signature

    Background:
        * def type = "PAdES"
        * def subtype = "Cachet serveur"
        * def name = "PAdES - Cachet serveur - PDF_sans_tags - repositionnement signature"
        * def files = [ { file: "PDF_sans_tags.pdf" } ]
        * def positions = { "PDF_sans_tags.pdf": {"signatureNumber":0,"page":"1","x":200,"y":700} }

    Scenario: Création des dossiers
        * v5.business.formatsDeSignature.seal(type, subtype, name, files, positions)

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
            "commonName": "Christian Buffin - Default tenant - Cachet serveur",
            "distinguishedName": "E=christian.buffin@libriciel.coop,CN=Christian Buffin - Default tenant - Cachet serveur,OU=Default tenant - Cachet serveur,O=Libriciel SCOP,L=Montpellier,ST=34 - Herault,C=FR",
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

    Scenario Outline: Vérifications des propriétés des signatures (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * def expected =
"""
[
    {
        "signedBy": "",
        "reason": "",
        "location": ""
    }
]
"""
        * match utils.signature.pdf.getFields(download.base + "/PDF_sans_tags.pdf") == expected

        Examples:
            | details        | key       | signedBy            | reason                    | location    |
            | sans surcharge | normal    | Prenom Nom - Usages | Nacarat                   | Montpellier |
            | avec surcharge | surcharge | Prenom Nom - Usages | Responsable des méthodes  | Agde        |
