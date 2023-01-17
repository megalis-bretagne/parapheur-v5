@business @ip4 @formats-de-signature @folder
Feature: PAdES - Cachet serveur - PDF_avec_tags - signe_pades

    Background:
        * ip.pause(1)
        * def type = "PAdES"
        * def subtype = "Cachet serveur"
        * def name = "PAdES - Cachet serveur - PDF_avec_tags - signe_pades"
        * def files = [ { file: "classpath:files/formats/PDF_avec_tags/PDF_avec_tags-signature_pades.pdf" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * ip4.business.formatsDeSignature.seal(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des documents (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * match download.files == [ "PDF_avec_tags-signature_pades.pdf" ]

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures électroniques (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
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
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * def expected =
"""
[
    "#(ip.signature.pades.fields.default('Christian Noir - Recette i-parapheur', 'Responsable des méthodes', 'Montpellier'))",
    "#(ip.signature.pades.fields.default('<signedBy>', '<reason>', '<location>'))"
]
"""
        * match ip.signature.pades.fields.read(download.base + "/PDF_avec_tags-signature_pades.pdf") == expected

        Examples:
            | key       | signedBy                                           | reason | location |
            | normal    | Christian Buffin - Default tenant - Cachet serveur |        |          |
            | surcharge | Christian Buffin - Default tenant - Cachet serveur |        |          |

    Scenario Outline: Vérifications des annotations (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * def expected =
"""
{
    "page 1": {
        "1": "#(ip4.signature.pades.annotations.default([350, 6, 519, 59], 'Christian Noir', 'Responsable des méthodes'))"
    },
    "page 3": {
        "1": "#(ip4.signature.pades.annotations.default(<position>))"
    }
}
"""
        * match ip.signature.pades.annotations.read(download.base + "/PDF_avec_tags-signature_pades.pdf") == expected

        Examples:
            | key       | position!            |
            | normal    | [376, 197, 476, 297] |
            | surcharge | [376, 197, 476, 297] |

    Scenario Outline: Vérifications des grigris de signature (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * def actual = ip.signature.pades.images.export(download.base + "/PDF_avec_tags-signature_pades.pdf")
        * def expected =
"""
{
    "page 1": {
        "1": "#(ip4.signature.pades.images.expected('cnoir', 1))"
    },
    "page 3": {
        "1": "#(ip4.signature.pades.images.expected('cachet'))"
    }
}
"""
        * ip.signature.pades.images.compare(actual, expected)
        * match actual == ip.signature.pades.images.schema(expected)

        Examples:
            | key       |
            | normal    |
            | surcharge |
