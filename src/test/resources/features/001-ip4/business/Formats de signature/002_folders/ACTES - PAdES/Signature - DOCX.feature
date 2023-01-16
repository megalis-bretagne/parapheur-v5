@business @ip4 @formats-de-signature @folder @ignore
# @fixme: en v4, la conversion ne fonctionne qu'avec le protocole ACTES
# parapheur.document.openxml.accept=true dans alfresco-global.properties
Feature: ACTES - PAdES - Signature - DOCX

    Background:
        * ip.pause(1)
        * def type = "ACTES - PAdES"
        * def subtype = "Signature"
        * def name = "ACTES - PAdES - Signature - DOCX"
        * def files = [ { file: "document_ooxml.docx" } ]

    Scenario: Création et signature des dossiers (normal et surcharge)
        * ip4.business.formatsDeSignature.sign(type, subtype, name, files)

    Scenario Outline: Vérifications de la liste des documents (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * match download.files == [ "document_ooxml.pdf" ]

        Examples:
            | key       |
            | normal    |
            | surcharge |

    Scenario Outline: Vérifications des signatures électroniques (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.certificates.default('signature-user'))" ]
        * match ip.signature.pades.certificates.read(download.base + "/document_ooxml.pdf") == expected

        Examples:
            | key       |
            | normal    |
            | surcharge |

    @fixme-ip4 @issue-compose-579
    Scenario Outline: Vérifications des propriétés des signatures (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * def expected = [ "#(ip.signature.pades.fields.default('Prenom Nom - Usages', '<reason>', '<location>'))" ]
        * match ip.signature.pades.fields.read(download.base + "/document_ooxml.pdf") == expected

        Examples:
            | key       | reason                    | location    |
            | normal    | Nacarat                   | Montpellier |
            | surcharge | Responsable des méthodes | Agde        |

    Scenario Outline: Vérifications des annotations (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * def expected =
"""
{
    "page 1": {
        "1": "#(ip4.signature.pades.annotations.default([0, 0, 200, 70], '<line1>', '<line2>'))"
    }
}
"""
        * match ip.signature.pades.annotations.read(download.base + "/document_ooxml.pdf") == expected

        Examples:
            | key       | line1            | line2                    |
            | normal    | Florence Garance | Nacarat                  |

    @fixme-ip4 @issue-compose-579
    Scenario Outline: Vérifications des annotations (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * def expected =
"""
{
    "page 1": {
        "1": "#(ip4.signature.pades.annotations.default([0, 0, 200, 70], '<line1>', '<line2>'))"
    }
}
"""
        * match ip.signature.pades.annotations.read(download.base + "/document_ooxml.pdf") == expected

        Examples:
            | key       | line1            | line2                    |
            | surcharge | Gilles Nacarat   | Responsable des méthodes |

    Scenario Outline: Vérifications des grigris de signature (${key})
        * def download = ip4.business.formatsDeSignature.downloadSoap("ws@fds", "a123456", type, subtype, "Archive", name + " - <key>")
        * def actual = ip.signature.pades.images.export(download.base + "/document_ooxml.pdf")
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
