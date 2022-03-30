@business @metadonnees @proposal @setup
Feature: Paramétrage métier "Métadonnées"
# @info: https://gitlab.libriciel.fr/libriciel/pole-signature/i-Parapheur-v5/ip-web/-/issues/270
# @todo: problème, je ne peux pas valider mon étape avec la valeur booléenne false
    Background:
        * api_v1.auth.login('user', 'password')

    Scenario Outline: Create tenant "${name}"
        * call read('classpath:lib/setup/tenant.create.feature') __row

        Examples:
            | name        |
            | Métadonnées |

    Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
        * call read('classpath:lib/setup/user.create.feature') __row

        Examples:
            | tenant      | userName  | email               | firstName | lastName | password | privilege | notificationsCronFrequency |
            | Métadonnées | ecapucine | ecapucine@dom.local | Eliott    | Capucine | a123456  | NONE      | disabled                   |
            | Métadonnées | ws-meta   | ws-meta@dom.local   | Service   | Web      | a123456  | NONE      | disabled                   |

    Scenario Outline: Create metadata "${name}" of type ${type}
        * call read('classpath:lib/setup/metadata.create.feature') __row

        Examples:
            | tenant      | key                      | name                       | type    | restrictedValues!                                                                                   |
            | Métadonnées | booleen                  | Booléen                    | BOOLEAN | []                                                                                                  |
            | Métadonnées | date                     | Date                       | DATE    | []                                                                                                  |
            | Métadonnées | date_restreinte          | Date restreinte            | DATE    | ['2022-01-15', '2022-02-15', '2022-03-15']                                                          |
            | Métadonnées | nombre_virgule           | Nombre à virgule           | FLOAT   | []                                                                                                  |
            | Métadonnées | nombre_virgule_restreint | Nombre à virgule restreint | FLOAT   | [0, 1.5, 2.5]                                                                                       |
            | Métadonnées | nombre_entier            | Nombre entier              | INTEGER | []                                                                                                  |
            | Métadonnées | nombre_entier_restreint  | Nombre entier restreint    | INTEGER | [0, 1, 2]                                                                                           |
            | Métadonnées | texte                    | Texte                      | TEXT    | []                                                                                                  |
            | Métadonnées | texte_restreint          | Texte restreint            | TEXT    | ['0', ' ', 'a', 'b']                                                                                |
            | Métadonnées | url                      | URL                        | URL     | []                                                                                                  |
            | Métadonnées | url_restreint            | URL restreint              | URL     | ['http://www.lesoir.be', 'https://www.libriciel.fr/nos-logiciels/', 'https://gitlab.libriciel.fr/'] |

    Scenario Outline: Create desk "${name}" in "${tenant}"
        * call read('classpath:lib/setup/desk.create.feature') __row

        Examples:
            | tenant      | name       | owners!                 | parent! | associated! | permissions!                                                         |
            | Métadonnées | Capucine   | ['ecapucine@dom.local'] | ''      | []          | {'action': true}                                                     |
            | Métadonnées | WebService | ['ws-meta@dom.local']   | ''      | []          | {'action': true, 'archiving': true, 'chain': true, 'creation': true} |

    Scenario Outline: Create "${name}" one-step-workflow and associate it to the "${deskName}" desk in "${tenant}"
        * call read('classpath:lib/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant      | name                                   | deskName | type | mandatoryValidationMetadata!                                                                                                                                               | mandatoryRejectionMetadata!                                                                                                                                                |
            | Métadonnées | Aucune metadonnee                      | Capucine | VISA | []                                                                                                                                                                         | []                                                                                                                                                                         |
            | Métadonnées | Booleen rejet                          | Capucine | VISA | []                                                                                                                                                                         | ['booleen']                                                                                                                                                                |
            | Métadonnées | Booleen validation                     | Capucine | VISA | ['booleen']                                                                                                                                                                | []                                                                                                                                                                         |
            | Métadonnées | Booleen rejet et validation            | Capucine | VISA | ['booleen']                                                                                                                                                                | ['booleen']                                                                                                                                                                |
            | Métadonnées | Texte rejet                            | Capucine | VISA | []                                                                                                                                                                         | ['texte']                                                                                                                                                                  |
            | Métadonnées | Texte validation                       | Capucine | VISA | ['texte']                                                                                                                                                                  | []                                                                                                                                                                         |
            | Métadonnées | Texte rejet et validation              | Capucine | VISA | ['texte']                                                                                                                                                                  | ['texte']                                                                                                                                                                  |
            | Métadonnées | Toutes metadonnees validation et rejet | Capucine | VISA | ['booleen','date','date_restreinte','nombre_virgule','nombre_virgule_restreint','nombre_entier','nombre_entier_restreint','texte','texte_restreint','url','url_restreint'] | ['booleen','date','date_restreinte','nombre_virgule','nombre_virgule_restreint','nombre_entier','nombre_entier_restreint','texte','texte_restreint','url','url_restreint'] |

    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * call read('classpath:lib/setup/type.create.feature') __row

        Examples:
            | tenant      | name  | protocol | signatureFormat | signatureLocation | signatureZipCode | signatureVisible! | signaturePosition!     |
            | Métadonnées | PAdES | NONE     | PADES           | Montpellier       |                  | true              | {"x":0,"y":0,"page":1} |

    Scenario Outline: Create subtype "${name}" for type "${type}" and "${validationWorkflowId}" workflow in "${tenant}"
        * call read('classpath:lib/setup/subtype.create.feature') __row

        Examples:
            | tenant      | type  | name                                   | multiDocuments! | validationWorkflowId                   | sealAutomatic! | sealCertificateId | secureMailServerId |
            | Métadonnées | PAdES | Aucune métadonnée                      | false           | Aucune metadonnee                      | false          |                   |                    |
            | Métadonnées | PAdES | Booleen rejet                          | false           | Booleen rejet                          | false          |                   |                    |
            | Métadonnées | PAdES | Booleen validation                     | false           | Booleen validation                     | false          |                   |                    |
            | Métadonnées | PAdES | Booleen rejet et validation            | false           | Booleen rejet et validation            | false          |                   |                    |
            | Métadonnées | PAdES | Texte rejet                            | false           | Texte rejet                            | false          |                   |                    |
            | Métadonnées | PAdES | Texte validation                       | false           | Texte validation                       | false          |                   |                    |
            | Métadonnées | PAdES | Texte rejet et validation              | false           | Texte rejet et validation              | false          |                   |                    |
            | Métadonnées | PAdES | Toutes métadonnées validation et rejet | false           | Toutes metadonnees validation et rejet | false          |                   |                    |
