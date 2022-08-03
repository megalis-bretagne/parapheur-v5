@business @formats-de-signature @folder
Feature: PAdES - Signature - PDF_sans_tags - repositionnement signature

    Background:
        * def type = "PAdES"
        * def subtype = "Signature"
        * def name = "PAdES - Signature - PDF_sans_tags - repositionnement signature"
        * def files = [ { file: "PDF_sans_tags.pdf" } ]
        * def positions = { "PDF_sans_tags.pdf": {"signatureNumber":0,"page":"1","x":200,"y":700} }

    Scenario: Création des dossiers
        * v5.business.formatsDeSignature.sign(type, subtype, name, files, positions)

    Scenario Outline: Vérifications de la liste des documents (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files == [ "PDF_sans_tags.pdf" ]

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
        "commonName": "Prenom Nom - Usages",
        "distinguishedName": "E=christian.buffin@libriciel.coop,CN=Prenom Nom - Usages,OU=Usages,O=Collectivite ou organisation,L=Ville,ST=34 - Herault,C=FR",
        "algorithm": "SHA-256",
        "type": "ETSI.CAdES.detached",
        "wholeDocumentSigned": true,
        "valid": true
    }
]
"""
        * match ip.signature.pades.certificates.read(download.base + "/PDF_sans_tags.pdf") == expected

        Examples:
            | key       |
            | normal    |
            | surcharge |

    @fixme-ip
    Scenario Outline: Vérifications des propriétés des signatures (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
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
        * match ip.signature.pades.fields.read(download.base + "/PDF_sans_tags.pdf") == expected

        Examples:
            | key       | signedBy            | reason                    | location    |
            | normal    | Prenom Nom - Usages | Nacarat                   | Montpellier |
            | surcharge | Prenom Nom - Usages | Responsable des méthodes  | Agde        |
