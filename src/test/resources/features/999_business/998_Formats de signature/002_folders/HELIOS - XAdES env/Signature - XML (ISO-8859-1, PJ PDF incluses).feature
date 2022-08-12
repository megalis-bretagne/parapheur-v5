@business @formats-de-signature @folder @fixme-ip @issue-compose-579
Feature: HELIOS - XAdES env - Signature - XML (ISO-8859-1, PJ PDF incluses)

    Background:
        * def type = "HELIOS - XAdES env"
        * def subtype = "Signature"
        * def name = "HELIOS - XAdES env - Signature - XML (ISO-8859-1, PJ PDF incluses)"
        * def files = [ { file: "pesWithASAP_unsigned.xml" } ]

    Scenario: Création des dossiers
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files == [ "pesWithASAP_unsigned.xml" ]

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des signatures électroniques (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * ip.signature.helios.validateSchema(download.base + "/pesWithASAP_unsigned.xml")
        * ip.signature.helios.validate(download.base + "/pesWithASAP_unsigned.xml")
        * def expected = { "City": "<City>", "PostalCode": "<PostalCode>", "CountryName": "France", "ClaimedRole": "<ClaimedRole>" }
        * match ip.signature.helios.extract(download.base + "/pesWithASAP_unsigned.xml") == expected

        Examples:
            | key       | City        | PostalCode | ClaimedRole              |
            | normal    | Montpellier | 34000      | Nacarat                  |
            | surcharge | Agde        | 34300      | Responsable des méthodes |
