@business @formats-de-signature @folder
Feature: XAdES det - Signature - RTF - signe_xades

    Scenario Outline: Création et démarrage du dossier par ${username}
        * api_v1.auth.login("<username>", "<password>")
        * v5.business.api.draft.createAndSendSimple(__row)

        Examples:
            | tenant               | username | password | desktop    | mainFiles!                                                                     | type      | subtype   | name                                      | annotation |
            | Formats de signature | ws-fds   | a123456  | WebService | [ { file: "document_rtf.rtf", detached: "document_rtf/signature_xades.xml" } ] | XAdES det | Signature | XAdES det - Signature - RTF - signe_xades | démarrage  |

    Scenario Outline: Signature du dossier par "${username}" sur le bureau "${desktop}"
        * api_v1.auth.login("<username>", "<password>")
        * call read("classpath:lib/v5/business/api/folder/sign.feature") __row

        Examples:
            | tenant               | username | password | desktop | folder                                    | certificate | annotation |
            | Formats de signature | gnacarat | a123456  | Nacarat | XAdES det - Signature - RTF - signe_xades | signature   | signature  |

    Scenario: Vérifications des documents du dossier par "ws-fds" en fin de circuit sur le bureau "WebService"
        * api_v1.auth.login("ws-fds", "a123456")

        * def download = v5.business.api.folder.download("Formats de signature", "WebService", "finished", "XAdES det - Signature - RTF - signe_xades")
        * match download.files ==
"""
[
    "documents/document_rtf.rtf/document_rtf.rtf",
    "documents/document_rtf.rtf/document_rtf-0-signature_externe.xml"
    "documents/document_rtf.rtf/document_rtf-1-Gilles Nacarat.xml"
]
"""
        # Documents originaux
        * match karate.read("file://" + download.base + "/documents/document_rtf.rtf/document_rtf.rtf") == commonpath.read("document_rtf.rtf")
        * match karate.read("file://" + download.base + "/documents/document_rtf.rtf/document_rtf-0-signature_externe.xml") == commonpath.read("document_rtf/signature_xades.xml")
        # Fichier de signature
        # @todo: vérifier le jeton xades détaché
