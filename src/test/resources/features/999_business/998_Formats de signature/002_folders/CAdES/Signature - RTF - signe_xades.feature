@business @formats-de-signature @folder @fixme-ip
Feature: CAdES - Signature - RTF - signe_xades

    Background:
        * def type = "CAdES"
        * def subtype = "Signature"
        * def name = "CAdES - Signature - RTF - signe_xades"
        * def files = [ { file: "document_rtf.rtf", detached: "document_rtf/signature_xades.xml" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files == [ "document_rtf.rtf", "document_rtf-0-signature_externe.xml", "document_rtf-1-<user>.p7s" ]

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match karate.read("file://" + download.base + "/document_rtf.rtf") == commonpath.read("document_rtf.rtf")
        * match karate.read("file://" + download.base + "/document_rtf-0-signature_externe.xml") == commonpath.read("document_rtf/signature_xades.xml")

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures détachées (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * ip.signature.cades.check(download.base + "/document_rtf.rtf", download.base + "/document_rtf-1-<user>.p7s")

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |
