@business @ip5 @formats-de-signature @folder
Feature: XAdES det - Signature - RTF - signe_cades

    Background:
        * def type = "XAdES det"
        * def subtype = "Signature"
        * def name = "XAdES det - Signature - RTF - signe_cades"
        * def files = [ { file: "document_rtf.rtf", detached: "document_rtf/signature_cades.p7s" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * ip5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${key})
        * def download = ip5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files == [ "document_rtf.rtf", "document_rtf-0-signature_externe.p7s", "document_rtf-1-<user>.xml" ]

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${key})
        * def download = ip5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match karate.read("file://" + download.base + "/document_rtf.rtf") == ip.commonpath.read("document_rtf.rtf")
        * match karate.read("file://" + download.base + "/document_rtf-0-signature_externe.p7s") == ip.commonpath.read("document_rtf/signature_cades.p7s")

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures détachées (${key})
        * def download = ip5.business.formatsDeSignature.download("finished", name + " - <key>")

        * ip.signature.xades.validate(download.base + "/document_rtf.rtf", download.base + "/document_rtf-1-<user>.xml")

        * def expected = { "City": "<City>", "PostalCode": "<PostalCode>", "CountryName": "France", "ClaimedRole": "<ClaimedRole>" }
        * match ip.signature.xades.extract(download.base + "/document_rtf-1-<user>.xml") == expected

        Examples:
            | key       | user             | City        | PostalCode | ClaimedRole              |
            | normal    | Florence Garance | Montpellier | 34000      | Nacarat                  |
            | surcharge | Gilles Nacarat   | Agde        | 34300      | Responsable des méthodes |
