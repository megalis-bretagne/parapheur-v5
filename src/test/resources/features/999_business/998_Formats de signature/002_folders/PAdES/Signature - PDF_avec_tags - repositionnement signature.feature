@business @formats-de-signature @folder @fixme-ip
Feature: PAdES - Signature - PDF_avec_tags - repositionnement signature

    Background:
        * def type = "PAdES"
        * def subtype = "Signature"
        * def name = "PAdES - Signature - PDF_avec_tags - repositionnement signature"
        * def files = [ { file: "PDF_avec_tags.pdf" } ]
        * def positions = { "PDF_avec_tags.pdf": {"signatureNumber":0,"page":"1","x":200,"y":700} }

    Scenario: Création et signature des dossiers (normal et surcharge)
        * v5.business.formatsDeSignature.sign(type, subtype, name, files, positions)

    Scenario Outline: Vérifications de la liste des documents (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files == [ "PDF_avec_tags.pdf" ]

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures électroniques (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.certificates.default('signature-user'))" ]
        * match ip.signature.pades.certificates.read(download.base + "/PDF_avec_tags.pdf") == expected

        Examples:
            | key       |
            | normal    |
            | surcharge |

    @fixme-ip @issue-compose-579
    Scenario Outline: Vérifications des propriétés des signatures (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.fields.default('<signedBy>', '<reason>', '<location>'))" ]
        * match ip.signature.pades.fields.read(download.base + "/PDF_avec_tags.pdf") == expected

        Examples:
            | key       | signedBy            | reason                    | location    |
            | normal    | Prenom Nom - Usages | Nacarat                   | Montpellier |
            | surcharge | Prenom Nom - Usages | Responsable des méthodes  | Agde        |

    @fixme-ip @issue-compose-579
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
        * match ip.signature.pades.annotations.read(download.base + "/PDF_avec_tags.pdf") == expected

        Examples:
            | key       | position!            | line1            | line2                    |
            | normal    | [100, 665, 300, 735] | Florence Garance | Nacarat                  |
            | surcharge | [100, 665, 300, 735] | Gilles Nacarat   | Responsable des méthodes |

    Scenario Outline: Vérifications des grigris de signature (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def actual = ip.signature.pades.images.export(download.base + "/PDF_avec_tags.pdf")
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
