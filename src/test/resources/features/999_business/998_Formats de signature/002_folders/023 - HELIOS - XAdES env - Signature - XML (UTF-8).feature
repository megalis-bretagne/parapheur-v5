@business @formats-de-signature @folder
Feature: HELIOS - XAdES env - Signature - XML (UTF-8)

    Background:
        * def type = "HELIOS - XAdES env"
        * def subtype = "Signature"
        * def name = "HELIOS - XAdES env - Signature - XML (UTF-8)"
        * def files = [ { file: "PESALR1_unsigned.xml" } ]

    Scenario: Création des dossiers
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files == [ "PESALR1_unsigned.xml" ]

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des signatures électroniques (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * ip.signature.helios.validate(download.base + "/PESALR1_unsigned.xml")
        * def expected = { "City": "<City>", "PostalCode": "<PostalCode>", "CountryName": "France", "ClaimedRole": "<ClaimedRole>" }
        * match ip.signature.helios.extract(download.base + "/PESALR1_unsigned.xml") == expected

        Examples:
            | key       | City        | PostalCode | ClaimedRole              |
            | normal    | Montpellier | 34000      | Nacarat                  |
            | surcharge | Agde        | 34300      | Responsable des méthodes |
