@business @ip5 @formats-de-signature @folder
Feature: PAdES - Signature - PDF_sans_tags-signature_pades - signe_pades

    Background:
        * def type = "PAdES"
        * def subtype = "Signature"
        * def name = "PAdES - Signature - PDF_sans_tags-signature_pades"
        * def files = [ { file: "PDF_sans_tags-signature_pades.pdf" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * ip5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des documents (${key})
        * def download = ip5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files == [ "PDF_sans_tags-signature_pades.pdf" ]

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures électroniques (${key})
        * def download = ip5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected =
"""
[
    "#(ip.signature.pades.certificates.default('signature-cnoir', false))",
    "#(ip.signature.pades.certificates.default('signature-user'))"
]
"""
        * match ip.signature.pades.certificates.read(download.base + "/PDF_sans_tags-signature_pades.pdf") == expected

        Examples:
            | key       |
            | normal    |
            | surcharge |

    @fixme-ip5 @issue-compose-579
    Scenario Outline: Vérifications des propriétés des signatures (${key})
        * def download = ip5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected =
"""
[
    "#(ip.signature.pades.fields.default('Christian Noir - Recette i-parapheur', 'Responsable des méthodes', 'Montpellier'))",
    "#(ip.signature.pades.fields.default('<signedBy>', '<reason>', '<location>'))"
]
"""
        * match ip.signature.pades.fields.read(download.base + "/PDF_sans_tags-signature_pades.pdf") == expected

        Examples:
            | key       | signedBy            | reason                    | location    |
            | normal    | Prenom Nom - Usages | Nacarat                   | Montpellier |
            | surcharge | Prenom Nom - Usages | Responsable des méthodes | Agde        |

    Scenario Outline: Vérifications des annotations (${key})
        * def download = ip5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected =
"""
{
    "page 1": {
        "1": "#(ip.signature.pades.annotations.default(<position>, '<line1>', '<line2>'))"
    },
    "page 2": {
        "1": "#(ip4.signature.pades.annotations.default([342, 61, 536, 128], 'Christian Noir', 'Responsable des méthodes'))"
    }
}
"""
        * match ip.signature.pades.annotations.read(download.base + "/PDF_sans_tags-signature_pades.pdf") == expected

        Examples:
            | key       | position!       | line1            | line2                    |
            | normal    | [0, 0, 200, 70] | Florence Garance | Nacarat                  |

    @fixme-ip5 @issue-compose-579
    Scenario Outline: Vérifications des annotations (${key})
        * def download = ip5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected =
"""
{
    "page 1": {
        "1": "#(ip.signature.pades.annotations.default(<position>, '<line1>', '<line2>'))"
    },
    "page 2": {
        "1": "#(ip4.signature.pades.annotations.default([342, 61, 536, 128], 'Christian Noir', 'Responsable des méthodes'))"
    }
}
"""
        * match ip.signature.pades.annotations.read(download.base + "/PDF_sans_tags-signature_pades.pdf") == expected

        Examples:
            | key       | position!       | line1            | line2                    |
            | surcharge | [0, 0, 200, 70] | Gilles Nacarat   | Responsable des méthodes |

    Scenario Outline: Vérifications des grigris de signature (${key})
        * def download = ip5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def actual = ip.signature.pades.images.export(download.base + "/PDF_sans_tags-signature_pades.pdf")
        * def expected =
"""
{
    "page 1": {
        "1": "#(ip.signature.pades.images.expected('<username>'))"
    },
    "page 2": {
        "1": "#(ip.signature.pades.images.expected('cnoir', 1))"
    }
}
"""
        * ip.signature.pades.images.compare(actual, expected)
        * match actual == ip.signature.pades.images.schema(expected)

        Examples:
            | key       | username |
            | normal    | fgarance |
            | surcharge | gnacarat |
