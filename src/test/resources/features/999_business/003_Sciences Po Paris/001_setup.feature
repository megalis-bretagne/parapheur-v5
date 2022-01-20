@business @sciences-po-paris @setup-sciences-po-paris @proposal
Feature: Paramétrage métier Sciences Po Paris
    Background:
        * api_v1.auth.login('user', 'password')

    Scenario Outline: Create tenant "${name}"
        * call read('classpath:lib/setup/tenant.create.feature') __row

        Examples:
            | name              |
            | Sciences Po Paris |

    Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
        * call read('classpath:lib/setup/user.create.feature') __row

        Examples:
            | tenant         | userName | email              | firstName | lastName | password | privilege | notificationsCronFrequency |
            | Default tenant | icyan    | icyan@dom.local    | Isabelle  | Cyan     | a123456  | NONE      | disabled                   |
            | Default tenant | pmagenta | pmagenta@dom.local | Pierre    | Magenta  | a123456  | NONE      | disabled                   |
            | Default tenant | rjaune   | rjaune@dom.local   | Rébecca   | Jaune    | a123456  | NONE      | disabled                   |
            | Default tenant | ws-spp   | ws-spp@dom.local   | Service   | Web      | a123456  | NONE      | disabled                   |

    Scenario Outline: Associate user "${email}" with tenant "${tenant}"
        * call read('classpath:lib/setup/tenant.user.associate.feature') __row

        Examples:
            | email              | tenant            |
            | icyan@dom.local    | Sciences Po Paris |
            | pmagenta@dom.local | Sciences Po Paris |
            | rjaune@dom.local   | Sciences Po Paris |
            | ws-spp@dom.local   | Sciences Po Paris |

    Scenario Outline: Create desk "${name}" in "${tenant}"
        * call read('classpath:lib/setup/desk.create.feature') __row

        Examples:
            | tenant            | name       | owners!                | parent! | associated!          | permissions!                                       |
            | Sciences Po Paris | Jaune      | ['rjaune@dom.local']   | ''      | []                   | {'action': true}                                   |
            | Sciences Po Paris | Magenta    | ['pmagenta@dom.local'] | ''      | []                   | {'action': true}                                   |
            | Sciences Po Paris | Cyan       | ['icyan@dom.local']    | ''      | ['Jaune', 'Magenta'] | {'action': true, 'archiving': true, 'chain': true} |
            | Sciences Po Paris | WebService | ['ws-spp@dom.local']   | ''      | []                   | {'action': true, 'creation': true}                 |

    # @todo: autres metadonnées
    Scenario Outline: Create metadata "${name}" of type ${type}
        * call read('classpath:lib/setup/metadata.create.feature') __row

        Examples:
            | tenant            | key               | name                 | type | restrictedValues! |
            | Sciences Po Paris | date_service_fait | Date du service fait | DATE | []                |

    Scenario Outline: Create "${name}" one-step-workflow and associate it to the "${deskName}" desk in "${tenant}"
        * call read('classpath:lib/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant            | name | deskName | type | mandatoryMetadata!    |
            | Sciences Po Paris | Visa | Cyan     | VISA | ['date_service_fait'] |

    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * call read('classpath:lib/setup/type.create.feature') __row

        Examples:
            | tenant            | name  | description | protocol | signatureFormat | signatureLocation | signatureZipCode | signaturePosition! | workflowSelectionScript! |
            | Sciences Po Paris | VISA | Visa PAdES  |          | PADES           | Montpellier       |                  |                    | ''                       |

    Scenario Outline: Create subtype "${name}" for type "${type}" and "${workflow}" workflow in "${tenant}"
        * call read('classpath:lib/setup/subtype.create.feature') __row

        Examples:
            | tenant            | type | name         | description  | workflow! | sealCertificate! | workflowSelectionScript! | subtypeMetadataRequestList! |
            | Sciences Po Paris | VISA | VISA_MONODOC | Visa monodoc | 'Visa'    | ''               | ''                       | []                          |
