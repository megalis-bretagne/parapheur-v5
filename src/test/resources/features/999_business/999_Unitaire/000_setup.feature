@business @unitaire @proposal @setup
Feature: Paramétrage métier "Unitaire"

    Background:
        * api_v1.auth.login('user', 'password')

    Scenario Outline: Create tenant "${name}"
        * call read('classpath:lib/setup/tenant.create.feature') __row

        Examples:
            | name     |
            | Unitaire |

    Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
        * call read('classpath:lib/setup/user.create.feature') __row

        Examples:
            | tenant   | userName    | email                 | firstName | lastName | password | privilege | notificationsCronFrequency |
            | Unitaire | nmarron     | nmarron@dom.local     | Nadine    | Marron   | a123456  | NONE      | disabled                   |
            | Unitaire | ws-unitaire | ws-unitaire@dom.local | Service   | Web      | a123456  | NONE      | disabled                   |

#    Scenario Outline: Associate user "${email}" with tenant "${tenant}"
#        * call read('classpath:lib/setup/tenant.user.associate.feature') __row
#
#        Examples:
#            | email                 | tenant   |
#            | nmarron@dom.local     | Unitaire |
#            | ws-unitaire@dom.local | Unitaire |

    Scenario Outline: Create desk "${name}" in "${tenant}"
        * call read('classpath:lib/setup/desk.create.feature') __row

        Examples:
            | tenant   | name       | owners!                   | parent! | associated! | permissions!                                                         |
            | Unitaire | Marron     | ['nmarron@dom.local']     | ''      | []          | {'action': true, 'archiving': true, 'chain': true}                   |
            | Unitaire | WebService | ['ws-unitaire@dom.local'] | ''      | []          | {'action': true, 'archiving': true, 'chain': true, 'creation': true} |

    Scenario Outline: Create metadata "${name}" of type ${type}
        * call read('classpath:lib/setup/metadata.create.feature') __row

        Examples:
            | tenant   | key    | name                    | type | restrictedValues! |
            | Unitaire | refus  | Raison du refus         | TEXT | []                |
            | Unitaire | succes | Raison de la validation | TEXT | []                |

    # @todo: métadonnée obligatoire en cas de refus
    Scenario Outline: Create "${name}" one-step-workflow and associate it to the "${deskName}" desk in "${tenant}"
        * call read('classpath:lib/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant   | name                     | deskName | type      | mandatoryMetadata! |
            | Unitaire | Signature et metadonnees | Marron   | SIGNATURE | ['succes']         |
            | Unitaire | Visa et métadonnées      | Marron   | VISA      | ['succes']         |

    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * call read('classpath:lib/setup/type.create.feature') __row

        Examples:
            | tenant   | name  | description | protocol | signatureFormat | signatureLocation | signatureZipCode | signaturePosition! | workflowSelectionScript! |
            | Unitaire | CAdES | CAdES       |          | PKCS7           |                   |                  |                    | ''                       |

    Scenario Outline: Create subtype "${name}" for type "${type}" and "${workflow}" workflow in "${tenant}"
        * call read('classpath:lib/setup/subtype.create.feature') __row

        Examples:
            | tenant   | type  | name                     | description              | workflow!                  | sealCertificate! | workflowSelectionScript! | subtypeMetadataRequestList! |
            | Unitaire | CAdES | Signature et metadonnees | Signature et metadonnees | 'Signature et metadonnees' | ''               | ''                       | []                          |
