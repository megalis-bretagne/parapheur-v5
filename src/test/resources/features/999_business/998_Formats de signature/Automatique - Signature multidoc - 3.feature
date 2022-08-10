@business @formats-de-signature @folder @wip
Feature: Automatique - Signature multidoc - 3

    Background:
        * def type = "Automatique"
        * def subtype = "Signature multidoc"
        * def name = "Automatique - Signature multidoc - 3"
        * def files =
"""
[
    { file: "document_rtf.rtf", detached: "document_rtf/signature_cades.p7s" },
    { file: "document_office.doc", detached: "document_office/signature_xades.xml" },
    { file: "PDF_sans_tags.pdf" },
    { file: "PDF_sans_tags-signature_pades.pdf" }
]
"""

    Scenario: Création des dossiers
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des documents (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files ==
"""
[
    "document_rtf.rtf",
    "document_rtf-0-signature_externe.p7s",
    "document_rtf-1-<user>.p7s",
    "document_office.doc",
    "document_office-0-signature_externe.p7s",
    "document_office-1-<user>.p7s",
    "PDF_sans_tags.pdf",
    "PDF_sans_tags-1-<user>.p7s",
    "PDF_sans_tags-signature_pades.pdf"
]
"""

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match karate.read("file://" + download.base + "/document_rtf.rtf") == commonpath.read("document_rtf.rtf")
        * match karate.read("file://" + download.base + "/document_rtf-0-signature_externe.p7s") == commonpath.read("document_rtf/signature_cades.p7s")
        * match karate.read("file://" + download.base + "/document_office.doc") == commonpath.read("document_office.doc")
        * match karate.read("file://" + download.base + "/document_office-0-signature_externe.p7s") == commonpath.read("document_office/signature_cades.p7s")
        * match karate.read("file://" + download.base + "/PDF_sans_tags.pdf") == commonpath.read("PDF_sans_tags.pdf")

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures détachées (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * ip.signature.cades.check(download.base + "/document_rtf.rtf", download.base + "/document_rtf-1-<user>.p7s")
        * ip.signature.cades.check(download.base + "/document_office.doc", download.base + "/document_office-1-<user>.p7s")
        * ip.signature.cades.check(download.base + "/PDF_sans_tags.pdf", download.base + "/PDF_sans_tags-1-<user>.p7s")

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |


    Scenario Outline: Vérifications des signatures électroniques (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
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

    @fixme-ip @issue-compose-579
    Scenario Outline: Vérifications des propriétés des signatures (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
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
            | surcharge | Prenom Nom - Usages | Responsable des méthodes  | Agde        |

    @see-next-scenario
    Scenario Outline: Vérifications des annotations (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected =
"""
{
    "page 1": {
        "1": "#(ip.signature.pades.annotations.default(<position>, '<line1>', '<line2>'))"
    },
    "page 2": {
        "1": "#(v4.signature.pades.annotations.default([342, 61, 536, 128], 'Christian Noir', 'Responsable des méthodes'))"
    }
}
"""
        * match ip.signature.pades.annotations.read(download.base + "/PDF_sans_tags-signature_pades.pdf") == expected

        Examples:
            | key    | position!       | line1            | line2   |
            | normal | [0, 0, 200, 70] | Florence Garance | Nacarat |

    @fixme-ip @issue-compose-579 @see-previous-scenario
    Scenario Outline: Vérifications des annotations (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def expected =
"""
{
    "page 1": {
        "1": "#(ip.signature.pades.annotations.default(<position>, '<line1>', '<line2>'))"
    },
    "page 2": {
        "1": "#(v4.signature.pades.annotations.default([342, 61, 536, 128], 'Christian Noir', 'Responsable des méthodes'))"
    }
}
"""
        * match ip.signature.pades.annotations.read(download.base + "/PDF_sans_tags-signature_pades.pdf") == expected

        Examples:
            | key       | position!       | line1          | line2                    |
            | surcharge | [0, 0, 200, 70] | Gilles Nacarat | Responsable des méthodes |

    Scenario Outline: Vérifications des grigris de signature (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
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
