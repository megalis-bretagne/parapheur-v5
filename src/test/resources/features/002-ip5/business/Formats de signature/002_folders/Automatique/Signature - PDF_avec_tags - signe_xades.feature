@business @ip5 @formats-de-signature @folder @fixme-ip5
Feature: Automatique - Signature - PDF_avec_tags - signe_xades

    Background:
        * def type = "Automatique"
        * def subtype = "Signature"
        * def name = "Automatique - Signature - PDF_avec_tags - signe_xades"
        * def files = [ { file: "PDF_avec_tags.pdf", detached: "PDF_avec_tags/signature_xades.xml" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files == [ "PDF_avec_tags.pdf", "PDF_avec_tags-0-signature_externe.xml", "PDF_avec_tags-1-<user>.xml" ]

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match karate.read("file://" + download.base + "/PDF_avec_tags.pdf") == commonpath.read("PDF_avec_tags.pdf")
        * match karate.read("file://" + download.base + "/PDF_avec_tags-0-signature_externe.xml") == commonpath.read("PDF_avec_tags/signature_xades.xml")

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures détachées (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")

        * ip.signature.xades.validate(download.base + "/PDF_avec_tags.pdf", download.base + "/PDF_avec_tags-1-<user>.xml")

        * def expected = { "City": "<City>", "PostalCode": "<PostalCode>", "CountryName": "France", "ClaimedRole": "<ClaimedRole>" }
        * match ip.signature.xades.extract(download.base + "/PDF_avec_tags-1-<user>.xml") == expected

        Examples:
            | key       | user             | City        | PostalCode | ClaimedRole              |
            | normal    | Florence Garance | Montpellier | 34000      | Nacarat                  |
            | surcharge | Gilles Nacarat   | Agde        | 34300      | Responsable des méthodes |
