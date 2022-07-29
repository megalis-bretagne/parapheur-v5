@business @formats-de-signature @folder
Feature: PAdES - Cachet serveur - PDF_avec_tags

    Scenario Outline: Création et démarrage du dossier par ${username}
        * api_v1.auth.login("<username>", "<password>")
        * v5.business.api.draft.createAndSendSimple(__row)

        Examples:
            | tenant               | username | password | desktop    | mainFiles!                        | type  | subtype        | name                                   | annotation |
            | Formats de signature | ws-fds   | a123456  | WebService | [ { file: "PDF_avec_tags.pdf" } ] | PAdES | Cachet serveur | PAdES - Cachet serveur - PDF_avec_tags | démarrage  |

    Scenario Outline: Apposition du cacht serveur sur le dossier par "${username}" sur le bureau "${desktop}"
        * api_v1.auth.login("<username>", "<password>")

        * call read("classpath:lib/v5/business/api/folder/seal.feature") __row

        Examples:
            | tenant               | username | password | desktop | folder                                 | certificate | annotation |
            | Formats de signature | gnacarat | a123456  | Nacarat | PAdES - Cachet serveur - PDF_avec_tags | signature   | signature  |

    Scenario: Vérifications des documents du dossier par "ws-fds" en fin de circuit sur le bureau "WebService"
        * api_v1.auth.login("ws-fds", "a123456")

        * def download = v5.business.api.folder.download("Formats de signature", "WebService", "finished", "PAdES - Cachet serveur - PDF_avec_tags")
        * match download.files == ["documents/PDF_avec_tags.pdf/PDF_avec_tags.pdf"]

        # Document signé
        * def expectedSignatures =
"""
[
  {
    "commonName": "Christian Buffin - Default tenant - Cachet serveur",
    "distinguishedName": "E=christian.buffin@libriciel.coop,CN=Christian Buffin - Default tenant - Cachet serveur,OU=Default tenant - Cachet serveur,O=Libriciel SCOP,L=Montpellier,ST=34 - Herault,C=FR",
    "algorithm": "SHA-256",
    "type": "ETSI.CAdES.detached",
    "wholeDocumentSigned": true,
    "valid": true
  }
]
"""
        * match utils.signature.pdf.get(download.base + "/documents/PDF_avec_tags.pdf/PDF_avec_tags.pdf") == expectedSignatures
