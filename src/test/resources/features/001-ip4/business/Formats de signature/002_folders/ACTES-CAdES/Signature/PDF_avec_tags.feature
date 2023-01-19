@business @ip4 @formats-de-signature @folder
Feature: ACTES-CAdES - Signature - PDF_avec_tags

    Background:
        * ip.pause(2)
        * def type = "ACTES - CAdES"
        * def subtype = "Signature"
        * def name = "ACTES-CAdES - Signature - PDF_avec_tags"
        * def files = [ { file: "classpath:files/formats/PDF_avec_tags/PDF_avec_tags.pdf" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * ip4.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des documents (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * match download.files == [ "PDF_avec_tags.pdf", "PDF_avec_tags.pdf-1-<user>.p7s" ]

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * match karate.read("file://" + download.base + "/PDF_avec_tags.pdf") == ip.commonpath.read("PDF_avec_tags.pdf")

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures détachées (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * ip.signature.cades.check(download.base + "/PDF_avec_tags.pdf", download.base + "/PDF_avec_tags.pdf-1-<user>.p7s")

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |
