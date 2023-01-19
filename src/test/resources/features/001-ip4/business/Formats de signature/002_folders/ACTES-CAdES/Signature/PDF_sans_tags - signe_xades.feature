@business @ip4 @formats-de-signature @folder
Feature: ACTES-CAdES - Signature - PDF_sans_tags - signe_xades

    Background:
        * ip.pause(2)
        * def type = "ACTES - CAdES"
        * def subtype = "Signature"
        * def name = "ACTES-CAdES - Signature - PDF_sans_tags - signe_xades"
        * def files = [ { file: "classpath:files/formats/PDF_sans_tags/PDF_sans_tags.pdf", detached: "classpath:files/formats/PDF_sans_tags/signature_xades.xml" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * ip4.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * match download.files == [ "PDF_sans_tags.pdf", "PDF_sans_tags.pdf-0-signature_externe.xml", "PDF_sans_tags.pdf-1-<user>.p7s" ]

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * match karate.read("file://" + download.base + "/PDF_sans_tags.pdf") == ip.commonpath.read("PDF_sans_tags.pdf")
        * match karate.read("file://" + download.base + "/PDF_sans_tags.pdf-0-signature_externe.xml") == ip.commonpath.read("PDF_sans_tags/signature_xades.xml")

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures détachées (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * ip.signature.cades.check(download.base + "/PDF_sans_tags.pdf", download.base + "/PDF_sans_tags.pdf-1-<user>.p7s")

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |
