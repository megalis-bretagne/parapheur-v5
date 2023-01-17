@business @ip4 @formats-de-signature @folder
Feature: CAdES - Signature - RTF - signe_cades

    Background:
        * ip.pause(2)
        * def type = "CAdES"
        * def subtype = "Signature"
        * def name = "CAdES - Signature - RTF - signe_cades"
        * def files = [ { file: "classpath:files/formats/document_rtf/document_rtf.rtf", detached: "classpath:files/formats/document_rtf/signature_cades.p7s" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * ip4.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * match download.files == [ "document_rtf.rtf", "document_rtf.rtf-0-signature_externe.p7s", "document_rtf.rtf-1-<user>.p7s" ]

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * match karate.read("file://" + download.base + "/document_rtf.rtf") == ip.commonpath.read("document_rtf.rtf")
        * match karate.read("file://" + download.base + "/document_rtf.rtf-0-signature_externe.p7s") == ip.commonpath.read("document_rtf/signature_cades.p7s")

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures détachées (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * ip.signature.cades.check(download.base + "/document_rtf.rtf", download.base + "/document_rtf.rtf-1-<user>.p7s")

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |
