@business @ip4 @formats-de-signature @folder
Feature: HELIOS-XAdES env - Signature - XML (ISO-8859-1, PJ PDF incluses)

    Background:
        * ip.pause(2)
        * def type = "HELIOS - XAdES env"
        * def subtype = "Signature"
        * def name = "HELIOS-XAdES env - Signature - XML (ISO-8859-1, PJ PDF incluses)"
        * def files = [ { file: "classpath:files/formats/pesWithASAP_unsigned.xml", display: "classpath:files/pdf/visuel.pdf" } ]

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
        # java.lang.OutOfMemoryError: Java heap space ... en fait, non
        * ip.signature.helios.validateSchema(download.base + "/pesWithASAP_unsigned.xml")
        * ip.signature.helios.validate(download.base + "/pesWithASAP_unsigned.xml")
        # @fixme: ClaimedRole -> Responsable des mï¿½thodes
        # @info
        # encguess "build/ip4-folders/HELIOS-XAdES env - Signature - XML (ISO-8859-1, PJ PDF incluses) - surcharge - 97734f03-1614-4a4f-a6f2-ca5a9406475d/pesWithASAP_unsigned.xml"
        # build/ip4-folders/HELIOS-XAdES env - Signature - XML (ISO-8859-1, PJ PDF incluses) - surcharge - 97734f03-1614-4a4f-a6f2-ca5a9406475d/pesWithASAP_unsigned.xml        unknown
        # encguess "src/test/resources/files/formats/pesWithASAP_unsigned.xml"
        # src/test/resources/files/formats/pesWithASAP_unsigned.xml       US-ASCII
        * def expected = { "City": "<City>", "PostalCode": "<PostalCode>", "CountryName": "France", "ClaimedRole": "<ClaimedRole>" }
        * match ip.signature.helios.extract(download.base + "/pesWithASAP_unsigned.xml") == expected

        Examples:
            | key       | City        | PostalCode | ClaimedRole              |
            | normal    | Montpellier | 34000      | Nacarat                  |
            | surcharge | Agde        | 34300      | Responsable des méthodes |
