@business @formats-de-signature @folder
Feature: XAdES det - Signature - PDF_avec_tags - signe_cades

    Background:
        * def type = "XAdES det"
        * def subtype = "Signature"
        * def name = "XAdES det - Signature - PDF_avec_tags - signe_cades"
        * def files = [ { file: "PDF_avec_tags.pdf", detached: "PDF_avec_tags/signature_cades.p7s" } ]

    Scenario: Création des dossiers
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * match download.files == [ "PDF_avec_tags.pdf", "PDF_avec_tags-0-signature_externe.p7s", "PDF_avec_tags-1-<user>.xml" ]

        Examples:
            | details        | key       | user             |
            | sans surcharge | normal    | Florence Garance |
            | avec surcharge | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des fichiers non signés (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * match karate.read("file://" + download.base + "/PDF_avec_tags.pdf") == commonpath.read("PDF_avec_tags.pdf")
        * match karate.read("file://" + download.base + "/PDF_avec_tags-0-signature_externe.p7s") == commonpath.read("PDF_avec_tags/signature_cades.p7s")

        Examples:
            | details        | key       |
            | sans surcharge | normal    |
            | avec surcharge | surcharge |

    @todo-karate
    Scenario Outline: Vérifications des signatures détachées (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        # @todo: vérifier le jeton xades détaché

        Examples:
            | details        | key       | user             |
            | sans surcharge | normal    | Florence Garance |
            | avec surcharge | surcharge | Gilles Nacarat   |
