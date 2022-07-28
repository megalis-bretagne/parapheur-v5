@business @formats-de-signature @folder
Feature: Automatique - Signature - RTF

    Scenario Outline: Création et démarrage du dossier par ${username}
        * api_v1.auth.login("<username>", "<password>")
        * v5.business.api.draft.createAndSendSimple(__row)

        Examples:
            | tenant               | username | password | desktop    | mainFiles!                       | type        | subtype   | name                          | annotation |
            | Formats de signature | ws-fds   | a123456  | WebService | [ { file: "document_rtf.rtf" } ] | Automatique | Signature | Automatique - Signature - RTF | démarrage  |

    Scenario Outline: Signature du dossier par "${username}" sur le bureau "${desktop}"
        * api_v1.auth.login("<username>", "<password>")

        * call read("classpath:lib/v5/business/api/folder/sign.feature") __row

        Examples:
            | tenant               | username | password | desktop | folder                        | certificate | annotation |
            | Formats de signature | gnacarat | a123456  | Nacarat | Automatique - Signature - RTF | signature   | signature  |

    Scenario: Vérifications des documents du dossier par "ws-fds" en fin de circuit sur le bureau "WebService"
        * api_v1.auth.login("ws-fds", "a123456")

        * def download = v5.business.api.folder.download("Formats de signature", "WebService", "finished", "Automatique - Signature - RTF")
        * match download.files ==
"""
[
    "documents/document_rtf.rtf/document_rtf.rtf",
    "documents/document_rtf.rtf/document_rtf-1-Gilles Nacarat.p7s"
]
"""
        # Document original
        * match karate.read("file://" + download.base + "/documents/document_rtf.rtf/document_rtf.rtf") == commonpath.read("document_rtf.rtf")
        #  Fichier de signature
        * utils.signature.pkcs7.check(commonpath.absolute("document_rtf.rtf"), download.base + "/documents/document_rtf.rtf/document_rtf-1-Gilles Nacarat.p7s", karate.toAbsolutePath(templates.certificate.default("signature")["public"]))
