@business @ip5 @formats-de-signature @folder @fixme-ip5
Feature: Automatique - Signature - PDF_sans_tags - signe_cades

    Background:
        * def type = "Automatique"
        * def subtype = "Signature"
        * def name = "Automatique - Signature - PDF_sans_tags - signe_cades"
        * def files = [ { file: "PDF_sans_tags.pdf", detached: "PDF_sans_tags/signature_cades.p7s" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files == [ "PDF_sans_tags.pdf", "PDF_sans_tags-0-signature_externe.p7s", "PDF_sans_tags-1-<user>.p7s" ]

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match karate.read("file://" + download.base + "/PDF_sans_tags.pdf") == commonpath.read("PDF_sans_tags.pdf")
        * match karate.read("file://" + download.base + "/PDF_sans_tags-0-signature_externe.p7s") == commonpath.read("PDF_sans_tags/signature_cades.p7s")

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures détachées (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * ip.signature.cades.check(download.base + "/PDF_sans_tags.pdf", download.base + "/PDF_sans_tags-1-<user>.p7s")

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |
