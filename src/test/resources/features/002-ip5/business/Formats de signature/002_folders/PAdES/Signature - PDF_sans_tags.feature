@business @ip5 @formats-de-signature @folder @fixme-ip5
Feature: PAdES - Signature - PDF_sans_tags

    Background:
        * def type = "PAdES"
        * def subtype = "Signature"
        * def name = "PAdES - Signature - PDF_sans_tags"
        * def files = [ { file: "PDF_sans_tags.pdf" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des documents (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files == [ "PDF_sans_tags.pdf" ]

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures électroniques (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.certificates.default('signature-user'))" ]
        * match ip.signature.pades.certificates.read(download.base + "/PDF_sans_tags.pdf") == expected

        Examples:
            | key       |
            | normal    |
            | surcharge |

    @fixme-ip5 @issue-compose-579
    Scenario Outline: Vérifications des propriétés des signatures (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.fields.default('<signedBy>', '<reason>', '<location>'))" ]
        * match ip.signature.pades.fields.read(download.base + "/PDF_sans_tags.pdf") == expected

        Examples:
            | key       | signedBy            | reason                    | location    |
            | normal    | Prenom Nom - Usages | Nacarat                   | Montpellier |
            | surcharge | Prenom Nom - Usages | Responsable des méthodes  | Agde        |

    @fixme-ip5 @issue-compose-579
    Scenario Outline: Vérifications des annotations (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected =
"""
{
    "page 1": {
        "1": "#(ip.signature.pades.annotations.default(<position>, '<line1>', '<line2>'))"
    }
}
"""
        * match ip.signature.pades.annotations.read(download.base + "/PDF_sans_tags.pdf") == expected

        Examples:
            | key       | position!       | line1            | line2                    |
            | normal    | [0, 0, 200, 70] | Florence Garance | Nacarat                  |
            | surcharge | [0, 0, 200, 70] | Gilles Nacarat   | Responsable des méthodes |

    Scenario Outline: Vérifications des grigris de signature (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def actual = ip.signature.pades.images.export(download.base + "/PDF_sans_tags.pdf")
        * def expected =
"""
{
  "page 1": {
    "1": "#(ip.signature.pades.images.expected('<username>'))"
  }
}
"""
        * ip.signature.pades.images.compare(actual, expected)
        * match actual == ip.signature.pades.images.schema(expected)

        Examples:
            | key       | username |
            | normal    | fgarance |
            | surcharge | gnacarat |
