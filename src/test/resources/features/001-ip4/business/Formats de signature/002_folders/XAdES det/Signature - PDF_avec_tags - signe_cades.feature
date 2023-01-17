@business @ip4 @formats-de-signature @folder
Feature: XAdES det - Signature - PDF_avec_tags - signe_cades

    Background:
        * ip.pause(2)
        * def type = "XAdES det"
        * def subtype = "Signature"
        * def name = "XAdES det - Signature - PDF_avec_tags - signe_cades"
        * def files = [ { file: "classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf", detached: "classpath:files/formats/PDF_avec_tags/signature_cades.p7s" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * ip4.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * match download.files == [ "PDF_avec_tags.pdf", "PDF_avec_tags.pdf-0-signature_externe.p7s", "PDF_avec_tags.pdf-1-<user>.xml" ]

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * karate.log(download.base)
        * match karate.read("file://" + download.base + "/PDF_avec_tags.pdf") == ip.commonpath.read("PDF_avec_tags.pdf")
        * match karate.read("file://" + download.base + "/PDF_avec_tags.pdf-0-signature_externe.p7s") == ip.commonpath.read("PDF_avec_tags/signature_cades.p7s")

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures détachées (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")

        * ip4.signature.xades.validate(download.base + "/PDF_avec_tags.pdf", download.base + "/PDF_avec_tags.pdf-1-<user>.xml")

        * def expected = {"City":"#notpresent","PostalCode":"#notpresent","CountryName":"#notpresent","ClaimedRole":"#notpresent"}
        * match ip4.signature.xades.extract(download.base + "/PDF_avec_tags.pdf-1-<user>.xml") == expected

        Examples:
            | key       | user             | City        | PostalCode | ClaimedRole              |
            | normal    | Florence Garance | Montpellier | 34000      | Nacarat                  |
            | surcharge | Gilles Nacarat   | Agde        | 34300      | Responsable des méthodes |
