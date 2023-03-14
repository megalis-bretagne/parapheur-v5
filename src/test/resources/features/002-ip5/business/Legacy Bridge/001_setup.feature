@business @ip5 @legacy-bridge @setup
Feature: Paramétrage métier "Legacy Bridge"

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)

    Scenario Outline: Create tenant "${name}"
        * call read('classpath:lib/ip5/api/setup/tenant.create.feature') __row

        Examples:
            | name          |
            | Legacy Bridge |

    Scenario Outline: Create metadata "${name}" of type ${type}
        * call read('classpath:lib/ip5/api/setup/metadata.create.feature') __row

        Examples:
            | tenant        | key         | name                    | type    | restrictedValues! |
            | Legacy Bridge | mameta_bool | Ma métadonnée booléenne | BOOLEAN | []                |

    Scenario Outline: Create a seal certificate from file "${path}" in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/seal-certificate.create.feature') __row

        Examples:
            | tenant        | path                                                  | password                        | image!                                           |
            | Legacy Bridge | classpath:files/Default tenant - Seal Certificate.p12 | christian.buffin@libriciel.coop | 'classpath:files/images/cachet - benoit xvi.png' |

    Scenario Outline: Create a secure mail configuration "${name}" in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/secure-mail.create.feature') __row

        Examples:
            | tenant        | name            | url                                      | login                                 | password | entity |
            | Legacy Bridge | Recette mailSec | https://pastell.partenaire.libriciel.fr/ | ws-pa-cbuffin-recette-ip500ea-mailsec | a123456a123456  | 116    |

    Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/user.create.feature') __row

        Examples:
            | tenant        | userName                 | email                                                | firstName | lastName  | password | privilege | notificationsCronFrequency | administeredDesk |
            | Legacy Bridge | lvermillon@legacy-bridge | cbuffin+lvermillon-legacy-bridge@libriciel.net       | Lukas     | Vermillon | a123456a123456  | NONE      | disabled                   |  |
            | Legacy Bridge | ws@legacy-bridge         | cbuffin+ws-legacy-bridge-legacy-bridge@libriciel.net | Service   | Web       | a123456a123456  | NONE      | disabled                   |  |

    Scenario Outline: Create desk "${name}" in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/desk.create.feature') __row

        Examples:
            | tenant        | name       | owners!                                                  | parent! | associated! | permissions!                                                         |
            | Legacy Bridge | Vermillon  | ['cbuffin+lvermillon-legacy-bridge@libriciel.net']       | ''      | []          | {'action': true}                                                     |
            | Legacy Bridge | WebService | ['cbuffin+ws-legacy-bridge-legacy-bridge@libriciel.net'] | ''      | []          | {'action': true, 'archiving': true, 'chain': true, 'creation': true} |

    Scenario Outline: Create "${name}" workflow in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant        | name      | deskName  | type        | mandatoryValidationMetadata! | mandatoryRejectionMetadata! |
            | Legacy Bridge | Cachet    | Vermillon | SEAL        | []                           | []                          |
            | Legacy Bridge | Mailsec   | Vermillon | SECURE_MAIL | []                           | []                          |
            | Legacy Bridge | Signature | Vermillon | SIGNATURE   | []                           | []                          |
            | Legacy Bridge | Visa      | Vermillon | VISA        | []                           | []                          |

    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/type.create.feature') __row

        Examples:
            | tenant        | name          | protocol | signatureFormat | signatureLocation | signatureZipCode | signatureVisible! | signaturePosition!     |
            | Legacy Bridge | Auto monodoc  | NONE     | AUTO            | Montpellier       | 34000            | true              | {"x":0,"y":0,"page":1} |
            | Legacy Bridge | Auto multidoc | NONE     | AUTO            | Montpellier       | 34000            | true              | {"x":0,"y":0,"page":1} |
            | Legacy Bridge | PAdES         | NONE     | PADES           | Montpellier       |                  | true              | {"x":0,"y":0,"page":1} |

    Scenario Outline: Create subtype "${name}" for type "${type}" and "${validationWorkflowId}" workflow in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/subtype.create.feature') __row

        Examples:
            | tenant        | type          | name           | annotationsAllowed! | multiDocuments! | creationPermittedDeskIds! | creationWorkflowId | validationWorkflowId | externalSignatureConfigId | sealAutomatic! | sealCertificateId                                  | secureMailServerId | digitalSignatureMandatory! | workflowSelectionScript! | subtypeLayerList! | subtypeMetadataList!                                                                         | multiDocuments! |
            | Legacy Bridge | Auto monodoc  | sign avec meta | false               | false           | ['WebService']            |                    | Signature            |                           | null           |                                                    |                    | true                       |                          | []                | [{"metadataKey": "mameta_bool", "defaultValue": null, "mandatory": true, "editable": false}] | false           |
            | Legacy Bridge | Auto monodoc  | sign sans meta | false               | false           | ['WebService']            |                    | Signature            |                           | null           |                                                    |                    | true                       |                          | []                | []                                                                                           | false           |
            | Legacy Bridge | Auto monodoc  | visa avec meta | false               | false           | ['WebService']            |                    | Visa                 |                           | null           |                                                    |                    | true                       |                          | []                | [{"metadataKey": "mameta_bool", "defaultValue": null, "mandatory": true, "editable": false}] | false           |
            | Legacy Bridge | Auto monodoc  | visa sans meta | false               | false           | ['WebService']            |                    | Visa                 |                           | null           |                                                    |                    | true                       |                          | []                | []                                                                                           | false           |
            | Legacy Bridge | Auto multidoc | sign avec meta | false               | false           | ['WebService']            |                    | Signature            |                           | null           |                                                    |                    | true                       |                          | []                | [{"metadataKey": "mameta_bool", "defaultValue": null, "mandatory": true, "editable": false}] | true            |
            | Legacy Bridge | Auto multidoc | sign sans meta | false               | false           | ['WebService']            |                    | Signature            |                           | null           |                                                    |                    | true                       |                          | []                | []                                                                                           | true            |
            | Legacy Bridge | Auto multidoc | visa avec meta | false               | false           | ['WebService']            |                    | Visa                 |                           | null           |                                                    |                    | true                       |                          | []                | [{"metadataKey": "mameta_bool", "defaultValue": null, "mandatory": true, "editable": false}] | true            |
            | Legacy Bridge | Auto multidoc | visa sans meta | false               | false           | ['WebService']            |                    | Visa                 |                           | null           |                                                    |                    | true                       |                          | []                | []                                                                                           | true            |
            | Legacy Bridge | PAdES         | cachet         | false               | false           | ['WebService']            |                    | Cachet               |                           | null           | Christian Buffin - Default tenant - Cachet serveur |                    | true                       |                          | []                | []                                                                                           | false           |
            | Legacy Bridge | PAdES         | mailsec        | false               | false           | ['WebService']            |                    | Mailsec              |                           | null           | Christian Buffin - Default tenant - Cachet serveur | Recette mailSec    | true                       |                          | []                | []                                                                                           | false           |
