@business @formats-de-signature @folder
Feature: CAdES - Signature - PDF_sans_tags

    Scenario Outline: Création et démarrage du dossier par ${username}
        * api_v1.auth.login("<username>", "<password>")
        * v5.business.api.draft.createAndSendSimple(__row)

        Examples:
            | tenant               | username | password | desktop    | mainFiles!                        | type  | subtype   | name                              | annotation |
            | Formats de signature | ws-fds   | a123456  | WebService | [ { file: "PDF_sans_tags.pdf" } ] | CAdES | Signature | CAdES - Signature - PDF_sans_tags | démarrage  |

    Scenario Outline: Signature du dossier par "${username}" sur le bureau "${desktop}"
        * api_v1.auth.login("<username>", "<password>")

        * call read("classpath:lib/v5/business/api/folder/sign.feature") __row

        Examples:
            | tenant               | username | password | desktop | folder                            | certificate | annotation |
            | Formats de signature | gnacarat | a123456  | Nacarat | CAdES - Signature - PDF_sans_tags | signature   | signature  |

    Scenario: Vérifications des documents du dossier par "ws-fds" en fin de circuit sur le bureau "WebService"
        * api_v1.auth.login("ws-fds", "a123456")

        * def download = v5.business.api.folder.download("Formats de signature", "WebService", "finished", "CAdES - Signature - PDF_sans_tags")
        * match download.files ==
"""
[
    "documents/PDF_sans_tags.pdf/PDF_sans_tags.pdf",
    "documents/PDF_sans_tags.pdf/PDF_sans_tags-1-Gilles Nacarat.p7s"
]
"""
        # Document original
        * match karate.read("file://" + download.base + "/documents/PDF_sans_tags.pdf/PDF_sans_tags.pdf") == commonpath.read("PDF_sans_tags.pdf")
        # Fichier de signature
        * utils.signature.pkcs7.check(commonpath.absolute("PDF_sans_tags.pdf"), download.base + "/documents/PDF_sans_tags.pdf/PDF_sans_tags-1-Gilles Nacarat.p7s", karate.toAbsolutePath(templates.certificate.default("signature")["public"]))
