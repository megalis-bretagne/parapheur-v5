@business @ip4 @formats-de-signature @folder
Feature: Automatique - Signature - RTF - signe_xades

    Background:
        * ip.pause(2)
        * def type = "Automatique"
        * def subtype = "Signature"
        * def name = "Automatique - Signature - RTF - signe_xades"
        * def files = [ { file: "classpath:files/formats/document_rtf/document_rtf.rtf", detached: "classpath:files/formats/document_rtf/signature_xades.xml" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * ip4.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * match download.files == [ "document_rtf.rtf", "document_rtf.rtf-0-signature_externe.xml", "document_rtf.rtf-1-<user>.xml" ]

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * match karate.read("file://" + download.base + "/document_rtf.rtf") == ip.commonpath.read("document_rtf.rtf")
        * match karate.read("file://" + download.base + "/document_rtf.rtf-0-signature_externe.xml") == ip.commonpath.read("document_rtf/signature_xades.xml")

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures détachées (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")

        * ip4.signature.xades.validate(download.base + "/document_rtf.rtf", download.base + "/document_rtf.rtf-1-<user>.xml")

        * def expected = {"City":"#notpresent","PostalCode":"#notpresent","CountryName":"#notpresent","ClaimedRole":"#notpresent"}
        * match ip4.signature.xades.extract(download.base + "/document_rtf.rtf-1-<user>.xml") == expected

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |
