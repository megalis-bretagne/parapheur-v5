@business @formats-de-signature @folder
Feature: PAdES - Cachet serveur - PDF_avec_tags

    Background:
        * def type = "PAdES"
        * def subtype = "Cachet serveur"
        * def name = "PAdES - Cachet serveur - PDF_avec_tags"
        * def files = [ { file: "PDF_avec_tags.pdf" } ]

    Scenario: Création des dossiers
        * v5.business.formatsDeSignature.seal(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des documents (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files == [ "PDF_avec_tags.pdf" ]

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures électroniques (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
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
        * match ip.signature.pades.certificates.read(download.base + "/PDF_avec_tags.pdf") == expected

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des propriétés des signatures (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
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
        * match ip.signature.pades.fields.read(download.base + "/PDF_avec_tags.pdf") == expected

        Examples:
            | key       | signedBy            | reason                    | location    |
            | normal    | Prenom Nom - Usages | Nacarat                   | Montpellier |
            | surcharge | Prenom Nom - Usages | Responsable des méthodes  | Agde        |
