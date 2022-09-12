@business @ip5 @formats-de-signature @folder @fixme-ip
Feature: PAdES - Signature - PDF_avec_tags

    Background:
        * def type = "PAdES"
        * def subtype = "Signature"
        * def name = "PAdES - Signature - DOCX"
        * def files = [ { file: "document_ooxml.docx" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des documents (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files == [ "document_ooxml.pdf" ]

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures électroniques (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.certificates.default('signature-user'))" ]
        * match ip.signature.pades.certificates.read(download.base + "/document_ooxml.pdf") == expected

        Examples:
            | key       |
            | normal    |
            | surcharge |

    @fixme-ip @issue-compose-579
    Scenario Outline: Vérifications des propriétés des signatures (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.fields.default('Prenom Nom - Usages', '<reason>', '<location>'))" ]
        * match ip.signature.pades.fields.read(download.base + "/document_ooxml.pdf") == expected

        Examples:
            | key       | reason                    | location    |
            | normal    | Nacarat                   | Montpellier |
            | surcharge | Responsable des méthodes  | Agde        |

    @fixme-ip @issue-compose-579
    Scenario Outline: Vérifications des annotations (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected =
"""
{
    "page 1": {
        "1": "#(ip.signature.pades.annotations.default([0, 0, 200, 70], '<line1>', '<line2>'))"
    }
}
"""
        * match ip.signature.pades.annotations.read(download.base + "/document_ooxml.pdf") == expected

        Examples:
            | key       | line1            | line2                    |
            | normal    | Florence Garance | Nacarat                  |
            | surcharge | Gilles Nacarat   | Responsable des méthodes |

    Scenario Outline: Vérifications des grigris de signature (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def actual = ip.signature.pades.images.export(download.base + "/document_ooxml.pdf")
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
