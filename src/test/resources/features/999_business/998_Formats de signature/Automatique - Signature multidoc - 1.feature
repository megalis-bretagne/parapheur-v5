@business @formats-de-signature @folder @wip
Feature: Automatique - Signature multidoc - 1

    Background:
        * def type = "Automatique"
        * def subtype = "Signature multidoc"
        * def name = "Automatique - Signature multidoc - 1"
        * def files = [ { file: "PDF_avec_tags.pdf" }, { file: "PDF_sans_tags.pdf" } ]

    Scenario: Création des dossiers
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des documents (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files == [ "PDF_avec_tags.pdf", "PDF_sans_tags.pdf" ]

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures électroniques (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.certificates.default('signature-user'))" ]
        * match ip.signature.pades.certificates.read(download.base + "/PDF_avec_tags.pdf") == expected
        * match ip.signature.pades.certificates.read(download.base + "/PDF_sans_tags.pdf") == expected

        Examples:
            | key       |
            | normal    |
            | surcharge |

    @fixme-ip @issue-compose-579
    Scenario Outline: Vérifications des propriétés des signatures (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        # @todo: si ça ne diffère pas d'une ligne à l'autre, il faudrait le retirer des colonnes
        * def expected = [ "#(ip.signature.pades.fields.default('Prenom Nom - Usages', '<reason>', '<location>'))" ]
        * match ip.signature.pades.fields.read(download.base + "/PDF_avec_tags.pdf") == expected
        * match ip.signature.pades.fields.read(download.base + "/PDF_sans_tags.pdf") == expected

        Examples:
            | key       | signedBy            | reason                    | location    |
            | normal    | Prenom Nom - Usages | Nacarat                   | Montpellier |
            | surcharge | Prenom Nom - Usages | Responsable des méthodes  | Agde        |

    @fixme-ip @issue-compose-579 @issue-compose-todo
    Scenario Outline: Vérifications des annotations (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expectedAvec =
"""
{
    "page 3": {
        "1": "#(ip.signature.pades.annotations.default([120, 323, 220, 423], '<line1>', '<line2>'))"
    }
}
"""
        * match ip.signature.pades.annotations.read(download.base + "/PDF_avec_tags.pdf") == expectedAvec

        * def expectedSans =
"""
{
    "page 1": {
        "1": "#(ip.signature.pades.annotations.default([0, 0, 200, 70], '<line1>', '<line2>'))"
    }
}
"""
        * match ip.signature.pades.annotations.read(download.base + "/PDF_sans_tags.pdf") == expectedSans

        Examples:
            | key       | line1            | line2                    |
            | normal    | Florence Garance | Nacarat                  |
            | surcharge | Gilles Nacarat   | Responsable des méthodes |

    Scenario Outline: Vérifications des grigris de signature (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def actualAvec = ip.signature.pades.images.export(download.base + "/PDF_avec_tags.pdf")
        * def expectedAvec =
"""
{
    "page 3": {
        "1": "#(ip.signature.pades.images.expected('<username>'))"
    }
}
"""
        * ip.signature.pades.images.compare(actualAvec, expectedAvec)
        * match actualAvec == ip.signature.pades.images.schema(expectedAvec)

        * def actualSans = ip.signature.pades.images.export(download.base + "/PDF_avec_tags.pdf")
        * def expectedSans =
"""
{
    "page 1": {
        "1": "#(ip.signature.pades.images.expected('<username>'))"
    }
}
"""
        * ip.signature.pades.images.compare(actualSans, expectedSans)
        * match actualSans == ip.signature.pades.images.schema(expectedSans)

        Examples:
            | key       | username |
            | normal    | fgarance |
            | surcharge | gnacarat |
