@business @formats-de-signature @folder
Feature: Automatique - Signature - RTF

    Background:
        * def type = "Automatique"
        * def subtype = "Signature"
        * def name = "Automatique - Signature - RTF"
        * def files = [ { file: "document_rtf.rtf" } ]

    Scenario: Création des dossiers
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * match download.files == [ "document_rtf.rtf", "document_rtf-1-<user>.p7s" ]

        Examples:
            | details        | key       | user             |
            | sans surcharge | normal    | Florence Garance |
            | avec surcharge | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * match karate.read("file://" + download.base + "/document_rtf.rtf") == commonpath.read("document_rtf.rtf")

        Examples:
            | details        | key       |
            | sans surcharge | normal    |
            | avec surcharge | surcharge |

    Scenario Outline: Vérifications des signatures détachées (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * utils.signature.pkcs7.check(download.base + "/document_rtf.rtf", download.base + "/document_rtf-1-<user>.p7s", karate.toAbsolutePath(templates.certificate.default("signature")["public"]))

        Examples:
            | details        | key       | user             |
            | sans surcharge | normal    | Florence Garance |
            | avec surcharge | surcharge | Gilles Nacarat   |
