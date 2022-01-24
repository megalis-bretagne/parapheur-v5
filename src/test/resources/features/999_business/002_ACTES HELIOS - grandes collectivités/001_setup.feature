@actes-helios-grandes-collectivites @business @proposal @setup
Feature: Paramétrage métier ACTES HELIOS - grandes collectivités
    Background:
        * api_v1.auth.login('user', 'password')

    Scenario Outline: Create tenant "${name}"
        * call read('classpath:lib/setup/tenant.create.feature') __row

        Examples:
            | name                                 |
            | ACTES HELIOS - grandes collectivités |

    Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
        * call read('classpath:lib/setup/user.create.feature') __row

        Examples:
            | tenant         | userName | email             | firstName | lastName | password | privilege | notificationsCronFrequency |
            | Default tenant | arouge   | arouge@dom.local  | Alain     | Rouge    | a123456  | NONE      | disabled                   |
            | Default tenant | cvert    | cvert@dom.local   | Céline    | Vert     | a123456  | NONE      | disabled                   |
            | Default tenant | ibleu    | ibleu@dom.local   | Inès      | Bleu     | a123456  | NONE      | disabled                   |
            | Default tenant | ws-ahgc  | ws-ahgc@dom.local | Service   | Web      | a123456  | NONE      | disabled                   |

    Scenario Outline: Associate user "${email}" with tenant "${tenant}"
        * call read('classpath:lib/setup/tenant.user.associate.feature') __row

        Examples:
            | email             | tenant                               |
            | arouge@dom.local  | ACTES HELIOS - grandes collectivités |
            | cvert@dom.local   | ACTES HELIOS - grandes collectivités |
            | ibleu@dom.local   | ACTES HELIOS - grandes collectivités |
            | ws-ahgc@dom.local | ACTES HELIOS - grandes collectivités |

    Scenario Outline: Create desk "${name}" in "${tenant}"
        * call read('classpath:lib/setup/desk.create.feature') __row

        Examples:
            | tenant                               | name       | owners!               | parent! | associated! | permissions!                                       |
            | ACTES HELIOS - grandes collectivités | Bleu       | ['ibleu@dom.local']   | ''      | []          | {'action': true, 'archiving': true, 'chain': true} |
            | ACTES HELIOS - grandes collectivités | Rouge      | ['arouge@dom.local']  | ''      | []          | {'action': true, 'archiving': true, 'chain': true} |
            | ACTES HELIOS - grandes collectivités | Vert       | ['cvert@dom.local']   | ''      | []          | {'action': true, 'archiving': true, 'chain': true} |
            | ACTES HELIOS - grandes collectivités | WebService | ['ws-ahgc@dom.local'] | ''      | []          | {'action': true, 'creation': true}                 |

    Scenario Outline: Create metadata "${name}" of type ${type}
        * call read('classpath:lib/setup/metadata.create.feature') __row

        Examples:
            | tenant                               | key           | name              | type    | restrictedValues!                       |
            | ACTES HELIOS - grandes collectivités | GdaEntJurCode | Entité juridique  | INTEGER | []                                      |
            | ACTES HELIOS - grandes collectivités | GdaBjMontant  | Montant du BJ     | FLOAT   | []                                      |
            | ACTES HELIOS - grandes collectivités | GdaBjType     | Type de bordereau | INTEGER | [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] |

    Scenario Outline: Create "${name}" one-step-workflow and associate it to the "${deskName}" desk in "${tenant}"
        * call read('classpath:lib/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant                               | name             | deskName          | type      | mandatoryMetadata! |
            | ACTES HELIOS - grandes collectivités | Signature        | Bleu              | SIGNATURE | []                 |
            | ACTES HELIOS - grandes collectivités | Signature HELIOS | ##VARIABLE_DESK## | SIGNATURE | []                 |

    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * call read('classpath:lib/setup/type.create.feature') __row

        Examples:
            | tenant                               | name          | description                        | protocol | signatureFormat | signatureLocation | signatureZipCode | signaturePosition!       |
            | ACTES HELIOS - grandes collectivités | ACTES - CAdES | Signature CAdES (ACTES)            | ACTES    | PKCS7           |                   |                  |                          |
            | ACTES HELIOS - grandes collectivités | ACTES - PAdES | Signature PAdES (ACTES)            | ACTES    | PADES           | Bobigny           |                  | {"x":50,"y":50,"page":1} |
            | ACTES HELIOS - grandes collectivités | HELIOS        | Signature XAdES enveloppé (HELIOS) | HELIOS   | PES_V2          | Bobigny           | 93000            |                          |

    Scenario Outline: Create subtype "${name}" for type "${type}" and "${workflow}" workflow in "${tenant}"
        * call read('classpath:lib/setup/subtype.create.feature') __row

        # @todo: (modifier le script de sélection)
        Examples:
            | tenant                               | type          | name                    | description                     | workflow!   | sealCertificate! | workflowSelectionScript!                                       | subtypeMetadataRequestList!                                                                |
            | ACTES HELIOS - grandes collectivités | ACTES - CAdES | ACTES - CAdES - Monodoc | Signature CAdES monodoc (ACTES) | 'Signature' | ''               | ''                                                             | []                                                                                         |
            | ACTES HELIOS - grandes collectivités | ACTES - PAdES | ACTES - PAdES - Monodoc | Signature PAdES monodoc (ACTES) | 'Signature' | ''               | ''                                                             | []                                                                                         |
            | ACTES HELIOS - grandes collectivités | HELIOS        | HELIOS - Monodoc        | Signature HELIOS monodoc        | ''          | ''               | 'classpath:files/workflowSelectionScript/ahgc - HELIOS.groovy' | [{"metadataKey": "GdaBjType", "defaultValue": null, "mandatory": true, "editable": false}] |

    Scenario Outline: Set the signature image for user "${email}"
        * call read('classpath:lib/setup/user.signatureImage.create.feature') __row

        Examples:
            | tenant                               | email            | path                                          |
            | ACTES HELIOS - grandes collectivités | arouge@dom.local | classpath:files/images/signature - arouge.png |
            | ACTES HELIOS - grandes collectivités | cvert@dom.local  | classpath:files/images/signature - cvert.png  |
            | ACTES HELIOS - grandes collectivités | ibleu@dom.local  | classpath:files/images/signature - ibleu.png  |
