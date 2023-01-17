@business @ip4 @formats-de-signature @folder
Feature: ACTES - PAdES - Signature - PDF_avec_tags

    Background:
        * ip.pause(2)
        * def type = "ACTES - PAdES"
        * def subtype = "Signature"
        * def name = "ACTES - PAdES - Signature - PDF_avec_tags"
        * def files = [ { file: "classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * ip4.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des documents (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * match download.files == [ "PDF_avec_tags.pdf" ]

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures électroniques (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.certificates.default('signature-user'))" ]
        * match ip.signature.pades.certificates.read(download.base + "/PDF_avec_tags.pdf") == expected

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des propriétés des signatures (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.fields.default('<signedBy>', '<reason>', '<location>'))" ]
        * match ip.signature.pades.fields.read(download.base + "/PDF_avec_tags.pdf") == expected

        Examples:
            | key       | signedBy            | reason                   | location    |
            | normal    | Prenom Nom - Usages | Nacarat                  | Montpellier |
            | surcharge | Prenom Nom - Usages | Responsable des méthodes | Agde        |

    Scenario Outline: Vérifications des annotations (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * def expected =
"""
{
    "page 3": {
        "1": "#(ip4.signature.pades.annotations.default(<position>, '<line1>', '<line2>'))"
    }
}
"""
        * match ip.signature.pades.annotations.read(download.base + "/PDF_avec_tags.pdf") == expected

        Examples:
            | key       | position!            | line1            | line2                    |
            | normal    | [120, 323, 220, 423] | Florence Garance | Nacarat                  |
            | surcharge | [120, 323, 220, 423] | Gilles Nacarat   | Responsable des méthodes |

    Scenario Outline: Vérifications des grigris de signature (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * def actual = ip.signature.pades.images.export(download.base + "/PDF_avec_tags.pdf")
        * def expected =
"""
{
  "page 3": {
    "1": "#(ip4.signature.pades.images.expected('<username>'))"
  }
}
"""
        * ip.signature.pades.images.compare(actual, expected)
        * match actual == ip.signature.pades.images.schema(expected)

        Examples:
            | key       | username |
            | normal    | fgarance |
            | surcharge | gnacarat |
