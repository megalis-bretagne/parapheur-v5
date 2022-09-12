@business @formats-de-signature @folder @ip4 @ip5 @ignore
Feature: Automatique - Signature - PDF_avec_tags

    Background:
        * def type = "Automatique"
        * def subtype = "Signature"
        * def name = "Automatique - Signature - PDF_avec_tags"
        * def files = [ { file: "PDF_avec_tags.pdf" } ]
    @x-wip
    Scenario: Test
        * karate.log(JSON.stringify(karate.properties))
        * karate.log(ip.version())

        # ...
        * karate.log(ip.currentVersion())

        # Tags utilisés
        * karate.log(karate.options)

        # Tags du test
        * karate.log(karate.tags.indexOf('ip4') !== -1)

    Scenario: Création et signature des dossiers (normal et surcharge)
        * ip.business.fds.createAndSign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des documents (${key})
        * def download = ip.business.fds.download("finished", name + " - <key>")
        * match download.files == [ "PDF_avec_tags.pdf" ]

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures électroniques (${key})
        * def download = ip.business.fds.download("finished", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.certificates.default('signature-user'))" ]
        * match ip.signature.pades.certificates.read(download.base + "/PDF_avec_tags.pdf") == expected

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des propriétés des signatures (${key})
        * def download = ip.business.fds.download("finished", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.fields.default('<signedBy>', '<reason>', '<location>'))" ]
        * match ip.signature.pades.fields.read(download.base + "/PDF_avec_tags.pdf") == expected

        Examples:
            | key       | signedBy            | reason                    | location    |
            | normal    | Prenom Nom - Usages | Nacarat                   | Montpellier |
            | surcharge | Prenom Nom - Usages | Responsable des méthodes  | Agde        |

    Scenario Outline: Vérifications des annotations (${key})
        * def download = ip.business.fds.download("finished", name + " - <key>")
        * def expected =
"""
{
    "page 3": {
        "1": "#(ip.signature.pades.annotations.default(<position>, '<line1>', '<line2>'))"
    }
}
"""
        * match ip.signature.pades.annotations.read(download.base + "/PDF_avec_tags.pdf") == expected

        Examples:
            | key       | position!            | line1            | line2                    |
            | normal    | [120, 323, 220, 423] | Florence Garance | Nacarat                  |
            | surcharge | [120, 323, 220, 423] | Gilles Nacarat   | Responsable des méthodes |

    Scenario Outline: Vérifications des grigris de signature (${key})
        * def download = ip.business.fds.download("finished", name + " - <key>")
        * def actual = ip.signature.pades.images.export(download.base + "/PDF_avec_tags.pdf")
        * def expected =
"""
{
    "page 3": {
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
