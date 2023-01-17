@business @ip4 @formats-de-signature @folder @ignore @fixme
Feature: HELIOS - XAdES env - Signature - XML (ISO-8859-1, PJ PDF incluses)

    Background:
        * ip.pause(2)
        * def type = "HELIOS - XAdES env"
        * def subtype = "Signature"
        * def name = "HELIOS - XAdES env - Signature - XML (ISO-8859-1, PJ PDF incluses)"
        * def files = [ { file: "classpath:files/formats/pesWithASAP_unsigned.xml" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * ip4.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * match download.files == [ "pesWithASAP_unsigned.xml" ]

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des signatures électroniques (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * ip.signature.helios.validateSchema(download.base + "/pesWithASAP_unsigned.xml")
        * ip.signature.helios.validate(download.base + "/pesWithASAP_unsigned.xml")
        * def expected = { "City": "<City>", "PostalCode": "<PostalCode>", "CountryName": "France", "ClaimedRole": "<ClaimedRole>" }
        * match ip.signature.helios.extract(download.base + "/pesWithASAP_unsigned.xml") == expected

        Examples:
            | key       | City        | PostalCode | ClaimedRole              |
            | normal    | Montpellier | 34000      | Nacarat                  |
            | surcharge | Agde        | 34300      | Responsable des méthodes |
