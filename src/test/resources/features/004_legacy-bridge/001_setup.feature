@legacy-bridge @setup
Feature: Paramétrage métier "Legacy Bridge"

    Background:
        * api_v1.auth.login('user', 'password')

    Scenario Outline: Create tenant "${name}"
        * call read('classpath:lib/api/setup/tenant.create.feature') __row

        Examples:
            | name          |
            | Legacy Bridge |

    Scenario Outline: Create metadata "${name}" of type ${type}
        * call read('classpath:lib/api/setup/metadata.create.feature') __row

        Examples:
            | tenant        | key         | name                    | type    | restrictedValues! |
            | Legacy Bridge | mameta_bool | Ma métadonnée booléenne | BOOLEAN | []                |

    Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
        * call read('classpath:lib/api/setup/user.create.feature') __row

        Examples:
            | tenant        | userName         | email                      | firstName | lastName  | password | privilege | notificationsCronFrequency |
            | Legacy Bridge | lvermillon       | lvermillon@dom.local       | Lukas     | Vermillon | a123456  | NONE      | disabled                   |
            | Legacy Bridge | ws@legacy-bridge | ws-legacy-bridge@dom.local | Service   | Web       | a123456  | NONE      | disabled                   |

    Scenario Outline: Create desk "${name}" in "${tenant}"
        * call read('classpath:lib/api/setup/desk.create.feature') __row

        Examples:
            | tenant        | name       | owners!                        | parent! | associated! | permissions!                                                         |
            | Legacy Bridge | Vermillon  | ['lvermillon@dom.local']       | ''      | []          | {'action': true}                                                     |
            | Legacy Bridge | WebService | ['ws-legacy-bridge@dom.local'] | ''      | []          | {'action': true, 'archiving': true, 'chain': true, 'creation': true} |

    Scenario Outline: Create "${name}" workflow in "${tenant}"
        * call read('classpath:lib/api/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant        | name      | deskName  | type      | mandatoryValidationMetadata! | mandatoryRejectionMetadata! |
            | Legacy Bridge | Signature | Vermillon | SIGNATURE | []                           | []                          |
            | Legacy Bridge | Visa      | Vermillon | VISA      | []                           | []                          |

    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * call read('classpath:lib/api/setup/type.create.feature') __row

        Examples:
            | tenant        | name | protocol | signatureFormat | signatureLocation | signatureZipCode | signatureVisible! | signaturePosition!     |
            | Legacy Bridge | Auto | NONE     | AUTO            | Montpellier       | 34000            | true              | {"x":0,"y":0,"page":1} |

    Scenario Outline: Create subtype "${name}" for type "${type}" and "${validationWorkflowId}" workflow in "${tenant}"
        * call read('classpath:lib/api/setup/subtype.create.feature') __row

        Examples:
            | tenant        | type | name           | annotationsAllowed! | multiDocuments! | creationPermittedDeskIds! | creationWorkflowId | validationWorkflowId | externalSignatureConfigId | sealAutomatic! | sealCertificateId | secureMailServerId | digitalSignatureMandatory! | workflowSelectionScript! | subtypeLayerList! | subtypeMetadataList!                                                                         |
            | Legacy Bridge | Auto | sign avec meta | false               | false           | ['WebService']            |                    | Signature            |                           | null           |                   |                    | true                       |                          | []                | [{"metadataKey": "mameta_bool", "defaultValue": null, "mandatory": true, "editable": false}] |
            | Legacy Bridge | Auto | sign sans meta | false               | false           | ['WebService']            |                    | Signature            |                           | null           |                   |                    | true                       |                          | []                | []                                                                                           |
            | Legacy Bridge | Auto | visa avec meta | false               | false           | ['WebService']            |                    | Visa                 |                           | null           |                   |                    | true                       |                          | []                | [{"metadataKey": "mameta_bool", "defaultValue": null, "mandatory": true, "editable": false}] |
            | Legacy Bridge | Auto | visa sans meta | false               | false           | ['WebService']            |                    | Visa                 |                           | null           |                   |                    | true                       |                          | []                | []                                                                                           |
