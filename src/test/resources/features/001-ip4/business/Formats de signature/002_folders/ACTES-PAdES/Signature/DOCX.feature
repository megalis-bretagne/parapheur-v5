@business @ip4 @formats-de-signature @folder @not-dom-local @wip
# @info: en local, le visuel PDF ne se génère pas, d'où le tag @not-dom-local
# @info: pour pouvoir traiter des fichiers docx: parapheur.document.openxml.accept=true dans alfresco-global.properties
Feature: ACTES-PAdES - Signature - DOCX

    Background:
        * ip.pause(2)
        * def type = "ACTES - PAdES"
        * def subtype = "Signature"
        * def name = "ACTES-PAdES - Signature - DOCX"
        * def files = [ { file: "classpath:files/formats/document_ooxml/document_ooxml.docx" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * ip4.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des documents (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * match download.files == [ "document_ooxml.docx.pdf" ]

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures électroniques (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.certificates.default('signature-user'))" ]
        * match ip.signature.pades.certificates.read(download.base + "/document_ooxml.docx.pdf") == expected

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des propriétés des signatures (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.fields.default('Prenom Nom - Usages', '<reason>', '<location>'))" ]
        * match ip.signature.pades.fields.read(download.base + "/document_ooxml.docx.pdf") == expected

        Examples:
            | key       | reason                   | location    |
            | normal    | Nacarat                  | Montpellier |
            | surcharge | Responsable des méthodes | Agde        |

    Scenario Outline: Vérifications des annotations (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * def expected =
"""
{
    "page 1": {
        "1": "#(ip4.signature.pades.annotations.default(<position>, '<line1>', '<line2>'))"
    }
}
"""
        * match ip.signature.pades.annotations.read(download.base + "/document_ooxml.docx.pdf") == expected

        Examples:
            | key       | position!        | line1            | line2                    |
            | normal    | [0, 0, 100, 100] | Florence Garance | Nacarat                  |
            | surcharge | [0, 0, 100, 100] | Gilles Nacarat   | Responsable des méthodes |

    Scenario Outline: Vérifications des grigris de signature (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * def actual = ip.signature.pades.images.export(download.base + "/document_ooxml.docx.pdf")
        * def expected =
"""
{
  "page 1": {
    "1": "#(ip4.signature.pades.images.expected('<username>'))"
  }
}
"""
        * ip.signature.pades.images.compare(actual, expected)
        * match actual == ip.signature.pades.images.schema(expected)

        Examples:
            | key       | username |
            | normal    | fgarance |
            | surcharge | gnacarat |
