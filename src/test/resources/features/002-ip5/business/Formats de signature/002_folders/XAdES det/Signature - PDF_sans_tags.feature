@business @ip5 @formats-de-signature @folder @fixme-ip5
Feature: XAdES det - Signature - PDF_sans_tags

    Background:
        * def type = "XAdES det"
        * def subtype = "Signature"
        * def name = "XAdES det - Signature - PDF_sans_tags"
        * def files = [ { file: "PDF_sans_tags.pdf" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files == [ "PDF_sans_tags.pdf", "PDF_sans_tags-1-<user>.xml" ]

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match karate.read("file://" + download.base + "/PDF_sans_tags.pdf") == commonpath.read("PDF_sans_tags.pdf")

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures détachées (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")

        * ip.signature.xades.validate(download.base + "/PDF_sans_tags.pdf", download.base + "/PDF_sans_tags-1-<user>.xml")

        * def expected = { "City": "<City>", "PostalCode": "<PostalCode>", "CountryName": "France", "ClaimedRole": "<ClaimedRole>" }
        * match ip.signature.xades.extract(download.base + "/PDF_sans_tags-1-<user>.xml") == expected

        Examples:
            | key       | user             | City        | PostalCode | ClaimedRole              |
            | normal    | Florence Garance | Montpellier | 34000      | Nacarat                  |
            | surcharge | Gilles Nacarat   | Agde        | 34300      | Responsable des méthodes |
