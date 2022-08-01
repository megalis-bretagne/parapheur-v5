@business @formats-de-signature @folder @new-ok
Feature: CAdES - Signature - PDF_avec_tags - signe_xades

    Background:
        * def type = "CAdES"
        * def subtype = "Signature"
        * def name = "CAdES - Signature - PDF_avec_tags - signe_xades"
        * def files = [ { file: "PDF_avec_tags.pdf", detached: "PDF_avec_tags/signature_xades.xml" } ]

    Scenario: Création des dossiers
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * match download.files == [ "PDF_avec_tags.pdf", "PDF_avec_tags-0-signature_externe.xml", "PDF_avec_tags-1-<user>.p7s" ]

        Examples:
            | details        | key       | user             |
            | sans surcharge | normal    | Florence Garance |
            | avec surcharge | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * match karate.read("file://" + download.base + "/PDF_avec_tags.pdf") == commonpath.read("PDF_avec_tags.pdf")
        * match karate.read("file://" + download.base + "/PDF_avec_tags-0-signature_externe.xml") == commonpath.read("PDF_avec_tags/signature_xades.xml")

        Examples:
            | details        | key       |
            | sans surcharge | normal    |
            | avec surcharge | surcharge |

    Scenario Outline: Vérifications des signatures détachées (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * utils.signature.pkcs7.check(download.base + "/PDF_avec_tags.pdf", download.base + "/PDF_avec_tags-1-<user>.p7s", karate.toAbsolutePath(templates.certificate.default("signature")["public"]))

        Examples:
            | details        | key       | user             |
            | sans surcharge | normal    | Florence Garance |
            | avec surcharge | surcharge | Gilles Nacarat   |
