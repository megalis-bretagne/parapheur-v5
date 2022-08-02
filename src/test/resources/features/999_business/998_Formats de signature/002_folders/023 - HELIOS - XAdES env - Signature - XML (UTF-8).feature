@business @formats-de-signature @folder
Feature: HELIOS - XAdES env - Signature - XML (UTF-8)

    Background:
        * def type = "HELIOS - XAdES env"
        * def subtype = "Signature"
        * def name = "HELIOS - XAdES env - Signature - XML (UTF-8)"
        * def files = [ { file: "PESALR1_unsigned.xml" } ]

    Scenario: Création des dossiers
        * v5.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des fichiers (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        * match download.files == [ "PESALR1_unsigned.xml" ]

        Examples:
            | details        | key       | user             |
            | sans surcharge | normal    | Florence Garance |
            | avec surcharge | surcharge | Gilles Nacarat   |

    Scenario Outline: Vérifications des signatures électroniques (${details})
        * def download = v5.business.formatsDeSignature.downloadFinished(name + " - <key>")
        # @todo: vérifier le fichier PES/XAdES enveloppé

        Examples:
            | details        | key       | user             |
            | sans surcharge | normal    | Florence Garance |
            | avec surcharge | surcharge | Gilles Nacarat   |
