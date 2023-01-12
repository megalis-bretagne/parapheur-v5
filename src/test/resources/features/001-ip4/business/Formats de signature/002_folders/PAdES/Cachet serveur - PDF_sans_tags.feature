@business @ip4 @formats-de-signature @folder
Feature: PAdES - Cachet serveur - PDF_sans_tags

    Background:
        * ip.pause(1)
        * def type = "PAdES"
        * def subtype = "Cachet serveur"
        * def name = "PAdES - Cachet serveur - PDF_sans_tags"
        * def files = [ { file: "classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * ip4.business.formatsDeSignature.seal(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des documents (${key})
        * def download = ip4.business.formatsDeSignature.download("a-archiver", name + " - <key>")
        * match download.files == [ "PDF_sans_tags.pdf" ]

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures électroniques (${key})
        * def download = ip4.business.formatsDeSignature.download("a-archiver", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.certificates.default('seal'))" ]
        * match ip.signature.pades.certificates.read(download.base + "/PDF_sans_tags.pdf") == expected

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des propriétés des signatures (${key})
        * def download = ip4.business.formatsDeSignature.download("a-archiver", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.fields.default('<signedBy>', '<reason>', '<location>'))" ]
        * match ip.signature.pades.fields.read(download.base + "/PDF_sans_tags.pdf") == expected

        Examples:
            | key       | signedBy                                           | reason | location |
            | normal    | Christian Buffin - Default tenant - Cachet serveur |        |          |
            | surcharge | Christian Buffin - Default tenant - Cachet serveur |        |          |

    Scenario Outline: Vérifications des annotations (${key})
        * def download = ip4.business.formatsDeSignature.download("a-archiver", name + " - <key>")
        * def expected =
"""
{
    "page 1": {
        "1": "#(ip4.signature.pades.annotations.default(<position>))"
    }
}
"""
        * match ip.signature.pades.annotations.read(download.base + "/PDF_sans_tags.pdf") == expected

        Examples:
            | key       | position!       |
            | normal    | [0, 0, 100, 100] |
            | surcharge | [0, 0, 100, 100] |
    @ignore @fixme-karate
    Scenario Outline: Vérifications des grigris de signature (${key})
        * def download = ip4.business.formatsDeSignature.download("a-archiver", name + " - <key>")
        * def actual = ip.signature.pades.images.export(download.base + "/PDF_sans_tags.pdf")
        * def expected =
"""
{
  "page 1": {
    "1": #(ip4.signature.pades.images.expected('cachet'))
  }
}
"""
        * ip.signature.pades.images.compare(actual, expected)
        * match actual == ip.signature.pades.images.schema(expected)

        Examples:
            | key       |
            | normal    |
            | surcharge |
