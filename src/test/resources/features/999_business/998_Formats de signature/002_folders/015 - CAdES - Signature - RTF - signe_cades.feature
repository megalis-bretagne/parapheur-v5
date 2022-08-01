@business @formats-de-signature @folder @new-ok
Feature: CAdES - Signature - RTF - signe_cades

    Background:
        * def type = "CAdES"
        * def subtype = "Signature"
        * def name = "CAdES - Signature - RTF - signe_cades"
        * def files = [ { file: "document_rtf.rtf", detached: "document_rtf/signature_cades.p7s" } ]

    Scenario: Création des dossiers
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * match download.files == [ "document_rtf.rtf", "document_rtf-0-signature_externe.p7s", "document_rtf-1-<user>.p7s" ]

        Examples:
            | details        | key       | user             |
            | sans surcharge | normal    | Florence Garance |
            | avec surcharge | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * match karate.read("file://" + download.base + "/document_rtf.rtf") == commonpath.read("document_rtf.rtf")
        * match karate.read("file://" + download.base + "/document_rtf-0-signature_externe.p7s") == commonpath.read("document_rtf/signature_cades.p7s")

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
