@actes-helios-petites-collectivites @business @proposal @setup
Feature: Paramétrage métier ACTES HELIOS - petites collectivités
    Background:
        * api_v1.auth.login('user', 'password')

    Scenario Outline: Create tenant "${name}"
        * call read('classpath:lib/setup/tenant.create.feature') __row

        Examples:
            | name                                 |
            | ACTES HELIOS - petites collectivités |

    Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
        * call read('classpath:lib/setup/user.create.feature') __row

        Examples:
            | tenant         | userName | email             | firstName | lastName | password | privilege | notificationsCronFrequency |
            | Default tenant | kmauve   | kmauve@dom.local  | Karima    | Mauve    | a123456  | NONE      | disabled                   |
            | Default tenant | ws-ahpc  | ws-ahpc@dom.local | Service   | Web      | a123456  | NONE      | disabled                   |

    Scenario Outline: Associate user "${email}" with tenant "${tenant}"
        * call read('classpath:lib/setup/tenant.user.associate.feature') __row

        Examples:
            | email             | tenant                               |
            | kmauve@dom.local  | ACTES HELIOS - petites collectivités |
            | ws-ahpc@dom.local | ACTES HELIOS - petites collectivités |

    Scenario Outline: Create desk "${name}" in "${tenant}"
        * call read('classpath:lib/setup/desk.create.feature') __row

        Examples:
            | tenant                               | name       | owners!               | parent! | associated! | permissions!                                       |
            | ACTES HELIOS - petites collectivités | Mauve      | ['kmauve@dom.local']  | ''      | []          | {'action': true, 'archiving': true, 'chain': true} |
            | ACTES HELIOS - petites collectivités | WebService | ['ws-ahpc@dom.local'] | ''      | []          | {'action': true, 'creation': true}                 |

    Scenario Outline: Create "${name}" one-step-workflow and associate it to the "${deskName}" desk in "${tenant}"
        * call read('classpath:lib/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant                               | name      | deskName | type      | mandatoryMetadata! |
            | ACTES HELIOS - petites collectivités | Signature | Mauve    | SIGNATURE | []                 |

    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * call read('classpath:lib/setup/type.create.feature') __row

        Examples:
            | tenant                               | name          | description                        | protocol | signatureFormat | signatureLocation | signatureZipCode | signaturePosition!       | workflowSelectionScript! |
            | ACTES HELIOS - petites collectivités | ACTES - CAdES | Signature CAdES (ACTES)            | ACTES    | PKCS7           |                   |                  |                          | ''                       |
            | ACTES HELIOS - petites collectivités | ACTES - PAdES | Signature PAdES (ACTES)            | ACTES    | PADES           | Montpellier       |                  | {"x":50,"y":50,"page":1} | ''                       |
            | ACTES HELIOS - petites collectivités | HELIOS        | Signature XAdES enveloppé (HELIOS) | HELIOS   | PES_V2          | Montpellier       | 34000            |                          | ''                       |

    Scenario Outline: Create subtype "${name}" for type "${type}" and "${workflow}" workflow in "${tenant}"
        * call read('classpath:lib/setup/subtype.create.feature') __row

        Examples:
            | tenant                               | type          | name                    | description                     | workflow!   | sealCertificate! | workflowSelectionScript! | subtypeMetadataRequestList! |
            | ACTES HELIOS - petites collectivités | ACTES - CAdES | ACTES - CAdES - Monodoc | Signature CAdES monodoc (ACTES) | 'Signature' | ''               | ''                       | []                          |
            | ACTES HELIOS - petites collectivités | ACTES - PAdES | ACTES - PAdES - Monodoc | Signature PAdES monodoc (ACTES) | 'Signature' | ''               | ''                       | []                          |
            | ACTES HELIOS - petites collectivités | HELIOS        | HELIOS - Monodoc        | Signature HELIOS monodoc        | 'Signature' | ''               | ''                       | []                          |

    Scenario Outline: Set the signature image for user "${email}"
        * call read('classpath:lib/setup/user.signatureImage.create.feature') __row

        Examples:
            | tenant                               | email            | path                                          |
            | ACTES HELIOS - petites collectivités | kmauve@dom.local | classpath:files/images/signature - kmauve.png |
