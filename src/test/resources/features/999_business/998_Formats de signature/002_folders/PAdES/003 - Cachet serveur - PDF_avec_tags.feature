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
        * def expected = [ "#(ip.signature.pades.certificates.default('seal'))" ]
        * match ip.signature.pades.certificates.read(download.base + "/PDF_avec_tags.pdf") == expected

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des propriétés des signatures (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.fields.default('<signedBy>', '<reason>', '<location>'))" ]
        * match ip.signature.pades.fields.read(download.base + "/PDF_avec_tags.pdf") == expected

        Examples:
            | key       | signedBy | reason | location |
            | normal    |          |        |          |
            | surcharge |          |        |          |

    @fixme-ip @issue-compose-579
    Scenario Outline: Vérifications des annotations (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected =
"""
{
    "page 3": {
        "1": "#(ip.signature.pades.annotations.default(<position>, '<line1>', '<line2>', '<line3>'))"
    }
}
"""
        * match ip.signature.pades.annotations.read(download.base + "/PDF_avec_tags.pdf") == expected

        Examples:
            | key       | position!            | line1 | line2 | line3 |
            | normal    | [323, 206, 523, 276] |       |       |       |
            | surcharge | [323, 206, 523, 276] |       |       |       |

    Scenario Outline: Vérifications des grigris de signature (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def actual = ip.signature.pades.images.export(download.base + "/PDF_avec_tags.pdf")
        * def expected =
"""
{
  "page 3": {
    "1": #(ip.signature.pades.images.expected('cachet'))
  }
}
"""
        * ip.signature.pades.images.compare(actual, expected)
        * match actual == ip.signature.pades.images.schema(expected)

        Examples:
            | key       |
            | normal    |
            | surcharge |
