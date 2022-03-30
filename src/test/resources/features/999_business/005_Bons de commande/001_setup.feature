@business @bons-de-commande @proposal @setup
Feature: Paramétrage métier "Bons de commande"

    Background:
        * api_v1.auth.login('user', 'password')

    Scenario Outline: Create tenant "${name}"
        * call read('classpath:lib/setup/tenant.create.feature') __row

        Examples:
            | name             |
            | Bons de commande |

    Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
        * call read('classpath:lib/setup/user.create.feature') __row

        Examples:
            | tenant           | userName | email              | firstName | lastName | password | privilege | notificationsCronFrequency |
            | Bons de commande | lfuchsia | lfuchsia@dom.local | Laëtitia  | Fuchsia  | a123456  | NONE      | disabled                   |
            | Bons de commande | findigo  | findigo@dom.local  | Françoise | Indigo   | a123456  | NONE      | disabled                   |
            | Bons de commande | opeche   | opeche@dom.local   | Olivier   | Pêche    | a123456  | NONE      | disabled                   |
            | Bons de commande | dpourpre | dpourpre@dom.local | Delphine  | Pourpre  | a123456  | NONE      | disabled                   |
            | Bons de commande | mrose    | mrose@dom.local    | Michèle   | Rose     | a123456  | NONE      | disabled                   |
            | Bons de commande | ws-bdc   | ws-bdc@dom.local   | Service   | Web      | a123456  | NONE      | disabled                   |

    Scenario Outline: Create metadata "${name}" of type ${type}
        * call read('classpath:lib/setup/metadata.create.feature') __row

        Examples:
            | tenant           | key     | name    | type  | restrictedValues!     |
            | Bons de commande | montant | Montant | FLOAT | []                    |
            | Bons de commande | service | Service | TEXT  | ['Indigo', 'Pourpre'] |

    Scenario Outline: Create desk "${name}" in "${tenant}"
        * call read('classpath:lib/setup/desk.create.feature') __row

        Examples:
            | tenant           | name       | owners!                | parent! | associated!         | permissions!                                                         |
            | Bons de commande | Fuchsia    | ['lfuchsia@dom.local'] | ''      | []                  | {'action': true}                                                     |
            | Bons de commande | Indigo     | ['findigo@dom.local']  | ''      | []                  | {'action': true}                                                     |
            | Bons de commande | Pêche      | ['opeche@dom.local']   | ''      | []                  | {'action': true}                                                     |
            | Bons de commande | Pourpre    | ['dpourpre@dom.local'] | ''      | []                  | {'action': true}                                                     |
            | Bons de commande | Rose       | ['mrose@dom.local']    | ''      | []                  | {'action': true}                                                     |
            | Bons de commande | WebService | ['ws-bdc@dom.local']   | ''      | ['Fuchsia', 'Rose'] | {'action': true, 'archiving': true, 'chain': true, 'creation': true} |

    Scenario Outline: Create "${name}" one-step-workflow and associate it to the "${deskName}" desk in "${tenant}"
        * call read('classpath:lib/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant           | name      | deskName          | type      | mandatoryValidationMetadata! |
            | Bons de commande | Signature | ##VARIABLE_DESK## | SIGNATURE | ['montant']                  |

    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * call read('classpath:lib/setup/type.create.feature') __row

        Examples:
            | tenant           | name            | description     | protocol | signatureFormat | signatureLocation | signatureZipCode | signatureVisible! | signaturePosition! | workflowSelectionScript! |
            | Bons de commande | Bon de commande | Bon de commande |          | PADES           | Montpellier       |                  | false             |                    | ''                       |

    Scenario Outline: Create subtype "${name}" for type "${type}" and "${validationWorkflowId}" workflow in "${tenant}"
        * call read('classpath:lib/setup/subtype.create.feature') __row

        Examples:
            | tenant           | type            | name                | description         | validationWorkflowId | secureMailServerId | sealCertificateId | workflowSelectionScript!                             | subtypeMetadataRequestList!                                                              |
            | Bons de commande | Bon de commande | Bureau variable     | Bureau variable     | Signature            |                    |                   | ''                                                   | []                                                                                       |
            | Bons de commande | Bon de commande | Script de sélection | Script de sélection |                      |                    |                   | 'classpath:files/workflowSelectionScript/bdc.groovy' | [{"metadataKey": "service", "defaultValue": null, "mandatory": true, "editable": false}] |

    Scenario Outline: Set the signature image for user "${email}"
        * call read('classpath:lib/setup/user.signatureImage.create.feature') __row

        Examples:
            | tenant           | email              | path                                            |
            | Bons de commande | lfuchsia@dom.local | classpath:files/images/signature - lfuchsia.png |
            | Bons de commande | findigo@dom.local  | classpath:files/images/signature - findigo.png  |
            | Bons de commande | opeche@dom.local   | classpath:files/images/signature - opeche.png   |
            | Bons de commande | dpourpre@dom.local | classpath:files/images/signature - dpourpre.png |
            | Bons de commande | mrose@dom.local    | classpath:files/images/signature - mrose.png    |
