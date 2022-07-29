@business @formats-de-signature @folder
Feature: XAdES det - Signature - PDF_avec_tags - signe_xades

    Scenario Outline: Création et démarrage du dossier par ${username}
        * api_v1.auth.login("<username>", "<password>")
        * v5.business.api.draft.createAndSendSimple(__row)

        Examples:
            | tenant               | username | password | desktop    | mainFiles!                                                                       | type      | subtype   | name                                                | annotation |
            | Formats de signature | ws-fds   | a123456  | WebService | [ { file: "PDF_avec_tags.pdf", detached: "PDF_avec_tags/signature_xades.xml" } ] | XAdES det | Signature | XAdES det - Signature - PDF_avec_tags - signe_xades | démarrage  |

    Scenario Outline: Signature du dossier par "${username}" sur le bureau "${desktop}"
        * api_v1.auth.login("<username>", "<password>")
        * call read("classpath:lib/v5/business/api/folder/sign.feature") __row

        Examples:
            | tenant               | username | password | desktop | folder                                              | certificate | annotation |
            | Formats de signature | gnacarat | a123456  | Nacarat | XAdES det - Signature - PDF_avec_tags - signe_xades | signature   | signature  |

    Scenario: Vérifications des documents du dossier par "ws-fds" en fin de circuit sur le bureau "WebService"
        * api_v1.auth.login("ws-fds", "a123456")

        * def download = v5.business.api.folder.download("Formats de signature", "WebService", "finished", "XAdES det - Signature - PDF_avec_tags - signe_xades")
        * match download.files ==
"""
[
    "documents/PDF_avec_tags.pdf/PDF_avec_tags.pdf",
    "documents/PDF_avec_tags.pdf/PDF_avec_tags-0-signature_externe.xml"
    "documents/PDF_avec_tags.pdf/PDF_avec_tags-1-Gilles Nacarat.xml"
]
"""
        # Documents originaux
        * match karate.read("file://" + download.base + "/documents/PDF_avec_tags.pdf/PDF_avec_tags.pdf") == commonpath.read("PDF_avec_tags.pdf")
        * match karate.read("file://" + download.base + "/documents/PDF_avec_tags.pdf/PDF_avec_tags-0-signature_externe.xml") == commonpath.read("PDF_avec_tags/signature_xades.xml")
        # Fichier de signature
        # @todo: vérifier le jeton xades détaché
