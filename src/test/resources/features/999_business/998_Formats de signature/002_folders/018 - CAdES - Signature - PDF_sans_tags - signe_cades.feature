@business @formats-de-signature @folder @new-ok
Feature: CAdES - Signature - PDF_sans_tags - signe_cades

    Background:
        * def type = "CAdES"
        * def subtype = "Signature"
        * def name = "CAdES - Signature - PDF_sans_tags - signe_cades"
        * def files = [ { file: "PDF_sans_tags.pdf", detached: "PDF_sans_tags/signature_cades.p7s" } ]

    Scenario: Création des dossiers
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * match download.files == [ "PDF_sans_tags.pdf", "PDF_sans_tags-0-signature_externe.p7s", "PDF_sans_tags-1-<user>.p7s" ]

        Examples:
            | details        | key       | user             |
            | sans surcharge | normal    | Florence Garance |
            | avec surcharge | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * match karate.read("file://" + download.base + "/PDF_sans_tags.pdf") == commonpath.read("PDF_sans_tags.pdf")
        * match karate.read("file://" + download.base + "/PDF_sans_tags-0-signature_externe.p7s") == commonpath.read("PDF_sans_tags/signature_cades.p7s")

        Examples:
            | details        | key       |
            | sans surcharge | normal    |
            | avec surcharge | surcharge |

    Scenario Outline: Vérifications des signatures détachées (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * utils.signature.pkcs7.check(download.base + "/PDF_sans_tags.pdf", download.base + "/PDF_sans_tags-1-<user>.p7s", karate.toAbsolutePath(templates.certificate.default("signature")["public"]))

        Examples:
            | details        | key       | user             |
            | sans surcharge | normal    | Florence Garance |
            | avec surcharge | surcharge | Gilles Nacarat   |
