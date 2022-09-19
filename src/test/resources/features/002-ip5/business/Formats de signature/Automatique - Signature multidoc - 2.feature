@business @ip5 @formats-de-signature @folder @ignore
Feature: Automatique - Signature multidoc - 2

    Background:
        * def type = "Automatique"
        * def subtype = "Signature multidoc"
        * def name = "Automatique - Signature multidoc - 2"
        * def files =
"""
[
    { file: "PDF_avec_tags.pdf", detached: "PDF_avec_tags/signature_cades.p7s" },
    { file: "PDF_sans_tags.pdf", detached: "PDF_sans_tags/signature_cades.p7s" }
]
"""

    Scenario: Création des dossiers
        * ip5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des documents (${key})
        * def download = ip5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files ==
"""
[
    "PDF_avec_tags.pdf",
    "PDF_avec_tags-0-signature_externe.p7s",
    "PDF_avec_tags-1-<user>.p7s",
    "PDF_sans_tags.pdf",
    "PDF_sans_tags-0-signature_externe.p7s",
    "PDF_sans_tags-1-<user>.p7s"
]
"""

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${key})
        * def download = ip5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match karate.read("file://" + download.base + "/PDF_avec_tags.pdf") == ip.commonpath.read("PDF_avec_tags.pdf")
        * match karate.read("file://" + download.base + "/PDF_avec_tags-0-signature_externe.p7s") == ip.commonpath.read("PDF_avec_tags/signature_cades.p7s")
        * match karate.read("file://" + download.base + "/PDF_sans_tags.pdf") == ip.commonpath.read("PDF_sans_tags.pdf")
        * match karate.read("file://" + download.base + "/PDF_sans_tags-0-signature_externe.p7s") == ip.commonpath.read("PDF_sans_tags/signature_cades.p7s")

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures détachées (${key})
        * def download = ip5.business.formatsDeSignature.download("finished", name + " - <key>")
        * ip.signature.cades.check(download.base + "/PDF_avec_tags.pdf", download.base + "/PDF_avec_tags-1-<user>.p7s")
        * ip.signature.cades.check(download.base + "/PDF_sans_tags.pdf", download.base + "/PDF_sans_tags-1-<user>.p7s")

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |
