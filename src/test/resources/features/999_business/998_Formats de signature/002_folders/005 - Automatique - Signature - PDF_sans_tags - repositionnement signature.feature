@business @formats-de-signature @folder
Feature: Automatique - Signature - PDF_sans_tags - repositionnement signature

    Scenario Outline: Création et démarrage du dossier par ${username}
        * api_v1.auth.login("<username>", "<password>")
        * v5.business.api.draft.createAndSendSimple(__row)

        Examples:
            | tenant               | username | password | desktop    | mainFiles!                        | type        | subtype   | name                                                                 | annotation |
            | Formats de signature | ws-fds   | a123456  | WebService | [ { file: "PDF_sans_tags.pdf" } ] | Automatique | Signature | Automatique - Signature - PDF_sans_tags - repositionnement signature | démarrage  |

    Scenario Outline: Signature du dossier par "${username}" sur le bureau "${desktop}"
        * api_v1.auth.login("<username>", "<password>")

        * call read("classpath:lib/v5/business/api/folder/sign.feature") __row

        Examples:
            | tenant               | username | password | desktop | folder                                                               | certificate | annotation | positions!                                                                |
            | Formats de signature | gnacarat | a123456  | Nacarat | Automatique - Signature - PDF_sans_tags - repositionnement signature | signature   | signature  | { "PDF_sans_tags.pdf": {"signatureNumber":0,"page":"1","x":200,"y":700} } |

    Scenario: Vérifications des documents du dossier par "ws-fds" en fin de circuit sur le bureau "WebService"
        * api_v1.auth.login("ws-fds", "a123456")

        * def download = v5.business.api.folder.download("Formats de signature", "WebService", "finished", "Automatique - Signature - PDF_sans_tags - repositionnement signature")
        * match download.files == ["documents/PDF_sans_tags.pdf/PDF_sans_tags.pdf"]

        # Document signé
        * def expectedSignatures =
"""
[
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
        * match utils.signature.pdf.get(download.base + "/documents/PDF_sans_tags.pdf/PDF_sans_tags.pdf") == expectedSignatures

        # Propriétés de la signature
        * def expectedFields =
"""
[
    {
      "signedBy": "Prenom Nom - Usages 0255a1b4395ffb247515869e69fcf51a89ba478b",
      "reason": "Nacarat",
      "location": "Montpellier"
    }
]
"""
        * match utils.signature.pdf.getFields(download.base + "/documents/PDF_sans_tags.pdf/PDF_sans_tags.pdf") == expectedFields
