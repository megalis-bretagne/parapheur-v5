@business @formats-de-signature @folder @fixme-ip
Feature: HELIOS - XAdES env - Signature - XML (ISO-8859-1, PJ PDF incluses)

    Scenario Outline: Création et démarrage du dossier par ${username}
        * api_v1.auth.login("<username>", "<password>")
        * v5.business.api.draft.createAndSendSimple(__row)

        Examples:
            | tenant               | username | password | desktop    | mainFiles!                               | type               | subtype   | name                                                               | annotation |
            | Formats de signature | ws-fds   | a123456  | WebService | [ { file: "pesWithASAP_unsigned.xml" } ] | HELIOS - XAdES env | Signature | HELIOS - XAdES env - Signature - XML (ISO-8859-1, PJ PDF incluses) | démarrage  |

    Scenario Outline: Signature du dossier par "${username}" sur le bureau "${desktop}"
        * api_v1.auth.login("<username>", "<password>")

        * call read("classpath:lib/v5/business/api/folder/sign.feature") __row

        Examples:
            | tenant               | username | password | desktop | folder                                                             | certificate | annotation |
            | Formats de signature | gnacarat | a123456  | Nacarat | HELIOS - XAdES env - Signature - XML (ISO-8859-1, PJ PDF incluses) | signature   | signature  |

    Scenario: Vérifications des documents du dossier par "ws-fds" en fin de circuit sur le bureau "WebService"
        * api_v1.auth.login("ws-fds", "a123456")

        * def download = v5.business.api.folder.download("Formats de signature", "WebService", "finished", "HELIOS - XAdES env - Signature - XML (ISO-8859-1, PJ PDF incluses)")
        * match download.files == [ "documents/pesWithASAP_unsigned.xml/pesWithASAP_unsigned.xml" ]

        # Document signé
        # @todo: vérifier le fichier PES/XAdES enveloppé
