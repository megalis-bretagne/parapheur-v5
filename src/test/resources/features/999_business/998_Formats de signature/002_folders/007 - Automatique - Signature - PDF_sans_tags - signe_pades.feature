@business @formats-de-signature @folder
Feature: Automatique - Signature - PDF_sans_tags - signe_pades

    Scenario Outline: Création et démarrage du dossier par ${username}
        * api_v1.auth.login("<username>", "<password>")
        * v5.business.api.draft.createAndSendSimple(__row)

        Examples:
            | tenant               | username | password | desktop    | mainFiles!                                        | type        | subtype   | name                                                  | annotation |
            | Formats de signature | ws-fds   | a123456  | WebService | [ { file: "PDF_sans_tags-signature_pades.pdf" } ] | Automatique | Signature | Automatique - Signature - PDF_sans_tags - signe_pades | démarrage  |

    Scenario Outline: Signature du dossier par "${username}" sur le bureau "${desktop}"
        * api_v1.auth.login("<username>", "<password>")

        * call read("classpath:lib/v5/business/api/folder/sign.feature") __row

        Examples:
            | tenant               | username | password | desktop | folder                                                | certificate | annotation |
            | Formats de signature | gnacarat | a123456  | Nacarat | Automatique - Signature - PDF_sans_tags - signe_pades | signature   | signature  |

    Scenario: Vérifications des documents du dossier par "ws-fds" en fin de circuit sur le bureau "WebService"
        * api_v1.auth.login("ws-fds", "a123456")

        * def download = v5.business.api.folder.download("Formats de signature", "WebService", "finished", "Automatique - Signature - PDF_sans_tags - signe_pades")
        * match download.files == [ "documents/PDF_sans_tags-signature_pades.pdf/PDF_sans_tags-signature_pades.pdf" ]

        * def expectedSignatures =
"""
[
  {
    "commonName": "Christian Noir - Recette i-parapheur",
    "distinguishedName": "E=christian.buffin@libriciel.coop,CN=Christian Noir - Recette i-parapheur,OU=Recette i-parapheur,O=Libriciel SCOP,L=Montpellier,ST=34 - Herault,C=FR",
    "algorithm": "SHA-256",
    "type": "ETSI.CAdES.detached",
    "wholeDocumentSigned": false,
    "valid": true
  },
  {
    "commonName": "Prenom Nom - Usages",
    "distinguishedName": "E=christian.buffin@libriciel.coop,CN=Prenom Nom - Usages,OU=Usages,O=Collectivite ou organisation,L=Ville,ST=34 - Herault,C=FR",
    "algorithm": "SHA-256",
    "type": "ETSI.CAdES.detached",
    "wholeDocumentSigned": true,
    "valid": true
  }
]
"""
        * match utils.signature.pdf.get(download.base + "/documents/PDF_sans_tags-signature_pades.pdf/PDF_sans_tags-signature_pades.pdf") == expectedSignatures
