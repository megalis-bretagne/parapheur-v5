@business @ip5 @formats-de-signature @folder @fixme-ip5
Feature: PAdES - Cachet serveur - PDF_avec_tags - signe_pades

    Background:
        * def type = "PAdES"
        * def subtype = "Cachet serveur"
        * def name = "PAdES - Cachet serveur - PDF_avec_tags - signe_pades"
        * def files = [ { file: "PDF_avec_tags-signature_pades.pdf" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * v5.business.formatsDeSignature.seal(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des documents (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files == [ "PDF_avec_tags-signature_pades.pdf" ]

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures électroniques (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected =
"""
[
    "#(ip.signature.pades.certificates.default('signature-cnoir', false))",
    "#(ip.signature.pades.certificates.default('seal'))"
]
"""
        * match ip.signature.pades.certificates.read(download.base + "/PDF_avec_tags-signature_pades.pdf") == expected

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des propriétés des signatures (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected =
"""
[
    "#(ip.signature.pades.fields.default('Christian Noir - Recette i-parapheur', 'Responsable des méthodes', 'Montpellier'))",
    "#(ip.signature.pades.fields.default('<signedBy>', '<reason>', '<location>'))"
]
"""
        * match ip.signature.pades.fields.read(download.base + "/PDF_avec_tags-signature_pades.pdf") == expected

        Examples:
            | key       | signedBy | reason | location |
            | normal    |          |        |          |
            | surcharge |          |        |          |

    @fixme-ip5 @issue-compose-579
    Scenario Outline: Vérifications des annotations (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected =
"""
{
    "page 1": {
        "1": "#(v4.signature.pades.annotations.default([350, 6, 519, 59], 'Christian Noir', 'Responsable des méthodes'))"
    },
    "page 3": {
        "1": "#(ip.signature.pades.annotations.default(<position>, '<line1>', '<line2>'))"
    }
}
"""
        * match ip.signature.pades.annotations.read(download.base + "/PDF_avec_tags-signature_pades.pdf") == expected

        Examples:
            | key       | position!            | line1 | line2 |
            | normal    | [323, 206, 523, 276] |       |       |
            | surcharge | [323, 206, 523, 276] |       |       |

    Scenario Outline: Vérifications des grigris de signature (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def actual = ip.signature.pades.images.export(download.base + "/PDF_avec_tags-signature_pades.pdf")
        * def expected =
"""
{
    "page 1": {
        "1": "#(ip.signature.pades.images.expected('cnoir', 1))"
    },
    "page 3": {
        "1": "#(ip.signature.pades.images.expected('cachet'))"
    }
}
"""
        * ip.signature.pades.images.compare(actual, expected)
        * match actual == ip.signature.pades.images.schema(expected)

        Examples:
            | key       |
            | normal    |
            | surcharge |
