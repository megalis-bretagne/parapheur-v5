@business @factures @proposal @setup
Feature: Paramétrage métier "Factures"
    Background:
        * api_v1.auth.login('user', 'password')

    Scenario Outline: Create tenant "${name}"
        * call read('classpath:lib/api/setup/tenant.create.feature') __row

        Examples:
            | name     |
            | Factures |

    Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
        * call read('classpath:lib/api/setup/user.create.feature') __row

        Examples:
            | tenant   | userName    | email                 | firstName | lastName | password | privilege | notificationsCronFrequency |
            | Factures | icyan       | icyan@dom.local       | Isabelle  | Cyan     | a123456  | NONE      | disabled                   |
            | Factures | pmagenta    | pmagenta@dom.local    | Pierre    | Magenta  | a123456  | NONE      | disabled                   |
            | Factures | rjaune      | rjaune@dom.local      | Rébecca   | Jaune    | a123456  | NONE      | disabled                   |
            | Factures | ws-factures | ws-factures@dom.local | Service   | Web      | a123456  | NONE      | disabled                   |

    Scenario Outline: Create desk "${name}" in "${tenant}"
        * call read('classpath:lib/api/setup/desk.create.feature') __row

        Examples:
            | tenant   | name       | owners!                   | parent! | associated!          | permissions!                                                         |
            | Factures | Jaune      | ['rjaune@dom.local']      | ''      | []                   | {'action': true}                                                     |
            | Factures | Magenta    | ['pmagenta@dom.local']    | ''      | []                   | {'action': true}                                                     |
            | Factures | Cyan       | ['icyan@dom.local']       | ''      | ['Jaune', 'Magenta'] | {'action': true}                                                     |
            | Factures | WebService | ['ws-factures@dom.local'] | ''      | []                   | {'action': true, 'archiving': true, 'chain': true, 'creation': true} |

    # @todo: autres metadonnées
    Scenario Outline: Create metadata "${name}" of type ${type}
        * call read('classpath:lib/api/setup/metadata.create.feature') __row

        Examples:
            | tenant   | key               | name                 | type | restrictedValues! |
            | Factures | date_service_fait | Date du service fait | DATE | []                |

    Scenario Outline: Create "${name}" one-step-workflow and associate it to the "${deskName}" desk in "${tenant}"
        * call read('classpath:lib/api/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant   | name | deskName | type | mandatoryValidationMetadata! |
            | Factures | Visa | Cyan     | VISA | ['date_service_fait']        |

    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * call read('classpath:lib/api/setup/type.create.feature') __row

        Examples:
            | tenant   | name | description | protocol | signatureFormat | signatureLocation | signatureZipCode | signatureVisible! | signaturePosition! | workflowSelectionScript! |
            | Factures | VISA | Visa PAdES  |          | PADES           | Montpellier       |                  | false             |                    | ''                       |
    # @fixme: sous-type créé, mais http call failed after 30030 milliseconds for url: /api/v1/admin/tenant/<uuid>/typology/type/<uuid>/subtype
    Scenario Outline: Create subtype "${name}" for type "${type}" and "${validationWorkflowId}" workflow in "${tenant}"
        * call read('classpath:lib/api/setup/subtype.create.feature') __row

        Examples:
            | tenant   | type | name         | description  | validationWorkflowId | secureMailServerId | sealCertificateId | workflowSelectionScript! | subtypeMetadataRequestList! |
            | Factures | VISA | VISA_MONODOC | Visa monodoc | Visa                 |                    |                   | ''                       | []                          |
