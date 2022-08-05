@business @formats-de-signature @folder
Feature: XAdES det - Signature - RTF

    Background:
        * def type = "XAdES det"
        * def subtype = "Signature"
        * def name = "XAdES det - Signature - RTF"
        * def files = [ { file: "document_rtf.rtf" } ]

    Scenario: Création des dossiers
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match download.files == [ "document_rtf.rtf", "document_rtf-1-<user>.xml" ]

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${key})
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * match karate.read("file://" + download.base + "/document_rtf.rtf") == commonpath.read("document_rtf.rtf")

        Examples:
            | key       |
            | normal    |
            | surcharge |

    @todo-karate
    Scenario Outline: Vérifications des signatures détachées (${key})
        # @todo: vérifier le jeton xades détaché
        * def download = v5.business.formatsDeSignature.download("finished", name + " - <key>")
        * def file = commonpath.absolute("document_rtf.rtf")
        * def token = download.base + "/document_rtf-1-<user>.xml"
        * def public = karate.toAbsolutePath(templates.certificate.default("signature")["public"])
        * def actual = ip.signature.xades.actual(file, token, public)
        * def expected = ip.signature.xades.expected(file, token, public)
        * match actual == expected

        Examples:
            | key       | user             |
            | normal    | Florence Garance |
            | surcharge | Gilles Nacarat   |
