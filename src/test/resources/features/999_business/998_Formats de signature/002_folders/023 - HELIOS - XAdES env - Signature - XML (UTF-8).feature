@business @formats-de-signature @folder
Feature: HELIOS - XAdES env - Signature - XML (UTF-8)

    Scenario Outline: Création et démarrage du dossier par ${username}
        * api_v1.auth.login("<username>", "<password>")
        * v5.business.api.draft.createAndSendSimple(__row)

        Examples:
            | tenant               | username | password | desktop    | mainFiles!                           | type               | subtype   | name                                         | annotation |
            | Formats de signature | ws-fds   | a123456  | WebService | [ { file: "PESALR1_unsigned.xml" } ] | HELIOS - XAdES env | Signature | HELIOS - XAdES env - Signature - XML (UTF-8) | démarrage  |

    Scenario Outline: Signature du dossier par "${username}" sur le bureau "${desktop}"
        * api_v1.auth.login("<username>", "<password>")

        * call read("classpath:lib/v5/business/api/folder/sign.feature") __row

        Examples:
            | tenant               | username | password | desktop | folder                                       | certificate | annotation |
            | Formats de signature | gnacarat | a123456  | Nacarat | HELIOS - XAdES env - Signature - XML (UTF-8) | signature   | signature  |

    Scenario: Vérifications des documents du dossier par "ws-fds" en fin de circuit sur le bureau "WebService"
        * api_v1.auth.login("ws-fds", "a123456")

        * def download = v5.business.api.folder.download("Formats de signature", "WebService", "finished", "HELIOS - XAdES env - Signature - XML (UTF-8)")
        * match download.files == [ "documents/PESALR1_unsigned.xml/PESALR1_unsigned.xml" ]

        # Document signé
        # @todo: vérifier le fichier PES/XAdES enveloppé
