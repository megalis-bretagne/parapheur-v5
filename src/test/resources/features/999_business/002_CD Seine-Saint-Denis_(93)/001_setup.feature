@business @cd93 @setup-cd93 @proposal
Feature: Paramétrage métier CD Seine-Saint-Denis (93)
    Background:
        * api_v1.auth.login('user', 'password')

    Scenario Outline: Create tenant "${name}"
        * call read('classpath:lib/setup/tenant.create.feature') __row

        Examples:
            | name                      |
            | CD Seine-Saint-Denis (93) |

    Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
        * call read('classpath:lib/setup/user.create.feature') __row

        Examples:
            | tenant         | userName | email             | firstName | lastName | password | privilege | notificationsCronFrequency |
            | Default tenant | arouge   | arouge@dom.local  | Alain     | Rouge    | a123456  | NONE      | disabled                   |
            | Default tenant | cvert    | cvert@dom.local   | Céline    | Vert     | a123456  | NONE      | disabled                   |
            | Default tenant | ibleu    | ibleu@dom.local   | Inès      | Bleu     | a123456  | NONE      | disabled                   |
            | Default tenant | ws-cd93  | ws-cd93@dom.local | Service   | Web      | a123456  | NONE      | disabled                   |

    Scenario Outline: Associate user "${email}" with tenant "${tenant}"
        * call read('classpath:lib/setup/tenant.user.associate.feature') __row

        Examples:
            | email             | tenant                    |
            | arouge@dom.local  | CD Seine-Saint-Denis (93) |
            | cvert@dom.local   | CD Seine-Saint-Denis (93) |
            | ibleu@dom.local   | CD Seine-Saint-Denis (93) |
            | ws-cd93@dom.local | CD Seine-Saint-Denis (93) |

    Scenario Outline: Create desk "${name}" in "${tenant}"
        * call read('classpath:lib/setup/desk.create.feature') __row

        Examples:
            | tenant                    | name       | owners!               | parent! | associated! | permissions!                                       |
            | CD Seine-Saint-Denis (93) | Bleu       | ['ibleu@dom.local']   | ''      | []          | {'action': true, 'archiving': true, 'chain': true} |
            | CD Seine-Saint-Denis (93) | Rouge      | ['arouge@dom.local']  | ''      | []          | {'action': true, 'archiving': true, 'chain': true} |
            | CD Seine-Saint-Denis (93) | Vert       | ['cvert@dom.local']   | ''      | []          | {'action': true, 'archiving': true, 'chain': true} |
            | CD Seine-Saint-Denis (93) | WebService | ['ws-cd93@dom.local'] | ''      | []          | {'action': true, 'creation': true}                 |

    Scenario Outline: Create "${name}" one-step-workflow and associate it to the "${deskName}" desk in "${tenant}"
        * call read('classpath:lib/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant                    | name             | deskName          | type      |
            | CD Seine-Saint-Denis (93) | Signature        | Bleu              | SIGNATURE |
            | CD Seine-Saint-Denis (93) | Signature HELIOS | ##VARIABLE_DESK## | SIGNATURE |

    Scenario Outline: Create metadata "${name}" of type ${type}
        * call read('classpath:lib/setup/metadata.create.feature') __row

        Examples:
            | tenant                    | key           | name              | type    | restrictedValues!                       |
            | CD Seine-Saint-Denis (93) | GdaEntJurCode | Entité juridique  | INTEGER | []                                      |
            | CD Seine-Saint-Denis (93) | GdaBjMontant  | Montant du BJ     | FLOAT   | []                                      |
            | CD Seine-Saint-Denis (93) | GdaBjType     | Type de bordereau | INTEGER | [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] |

    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * call read('classpath:lib/setup/type.create.feature') __row

        Examples:
            | tenant                    | name          | description                        | protocol | signatureFormat | signatureLocation | signatureZipCode | signaturePosition!       |
            | CD Seine-Saint-Denis (93) | ACTES - CAdES | Signature CAdES (ACTES)            | ACTES    | PKCS7           |                   |                  |                          |
            | CD Seine-Saint-Denis (93) | ACTES - PAdES | Signature PAdES (ACTES)            | ACTES    | PADES           | Bobigny           |                  | {"x":50,"y":50,"page":1} |
            | CD Seine-Saint-Denis (93) | HELIOS        | Signature XAdES enveloppé (HELIOS) | HELIOS   | PES_V2          | Bobigny           | 93000            |                          |
    # @fixme: Create subtype "HELIOS - Monodoc" for type "HELIOS" and "Signature HELIOS" workflow in "CD Seine-Saint-Denis (93)" -> http call failed after 30032 milliseconds
    Scenario Outline: Create subtype "${name}" for type "${type}" and "${workflow}" workflow in "${tenant}"
        * call read('classpath:lib/setup/subtype.create.feature') __row

        # @todo: (modifier le script de sélection)
        Examples:
            | tenant                    | type          | name                    | description                     | workflow!          | sealCertificate! | workflowSelectionScript!                                       | subtypeMetadataRequestList!                                                                |
            | CD Seine-Saint-Denis (93) | ACTES - CAdES | ACTES - CAdES - Monodoc | Signature CAdES monodoc (ACTES) | 'Signature'        | ''               | ''                                                             | []                                                                                         |
            | CD Seine-Saint-Denis (93) | ACTES - PAdES | ACTES - PAdES - Monodoc | Signature PAdES monodoc (ACTES) | 'Signature'        | ''               | ''                                                             | []                                                                                         |
            | CD Seine-Saint-Denis (93) | HELIOS        | HELIOS - Monodoc        | Signature HELIOS monodoc        | 'Signature HELIOS' | ''               | 'classpath:files/workflowSelectionScript/cd93 - HELIOS.groovy' | [{"metadataKey": "GdaBjType", "defaultValue": null, "mandatory": true, "editable": false}] |

    Scenario Outline: Set the signature image for user "${email}"
        * call read('classpath:lib/setup/user.signatureImage.create.feature') __row

        Examples:
            | tenant                    | email            | path                                          |
            | CD Seine-Saint-Denis (93) | arouge@dom.local | classpath:files/images/signature - arouge.png |
            | CD Seine-Saint-Denis (93) | cvert@dom.local  | classpath:files/images/signature - cvert.png  |
            | CD Seine-Saint-Denis (93) | ibleu@dom.local  | classpath:files/images/signature - ibleu.png  |
