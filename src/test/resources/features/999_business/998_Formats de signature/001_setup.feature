@business @formats-de-signature @proposal @setup
Feature: Paramétrage métier "Formats de signature"

    Background:
        * api_v1.auth.login('user', 'password')

    Scenario Outline: Create tenant "${name}"
        * call read('classpath:lib/setup/tenant.create.feature') __row

        Examples:
            | name                 |
            | Formats de signature |

    Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
        * call read('classpath:lib/setup/user.create.feature') __row

        Examples:
            | tenant               | userName | email              | firstName | lastName | password | privilege | notificationsCronFrequency |
            | Formats de signature | gnacarat | gnacarat@dom.local | Gilles    | Nacarat  | a123456  | NONE      | disabled                   |
            | Formats de signature | ws-fds   | ws-fds@dom.local   | Service   | Web      | a123456  | NONE      | disabled                   |

    Scenario Outline: Create desk "${name}" in "${tenant}"
        * call read('classpath:lib/setup/desk.create.feature') __row

        Examples:
            | tenant               | name       | owners!                | parent! | associated! | permissions!                                                         |
            | Formats de signature | Nacarat    | ['gnacarat@dom.local'] | ''      | []          | {'action': true}                                                     |
            | Formats de signature | WebService | ['ws-fds@dom.local']   | ''      | []          | {'action': true, 'archiving': true, 'chain': true, 'creation': true} |

    Scenario Outline: Create a seal certificate from file "${path}" in "${tenant}"
        * call read('classpath:lib/setup/seal-certificate.create.feature') __row

        Examples:
            | tenant             | path                                                  | password                        | image!                                                   |
            | Formats de signature | classpath:files/Default tenant - Seal Certificate.p12 | christian.buffin@libriciel.coop | 'classpath:files/images/cachet - circuits unitaires.png' |

    Scenario Outline: Create "${name}" one-step-workflow and associate it to the "${deskName}" desk in "${tenant}"
        * call read('classpath:lib/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant               | name           | deskName | type      | mandatoryMetadata! |
            | Formats de signature | Cachet serveur | Nacarat  | SEAL      | []                 |
            | Formats de signature | Signature      | Nacarat  | SIGNATURE | []                 |

    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * call read('classpath:lib/setup/type.create.feature') __row

        Examples:
            | tenant               | name               | protocol | signatureFormat | signatureLocation | signatureZipCode | signatureVisible! | signaturePosition!       |
            | Formats de signature | ACTES - CAdES      | ACTES    | PKCS7           |                   |                  | false              | {} |
            | Formats de signature | ACTES - PAdES      | ACTES    | PADES           | Montpellier       |                  | true              | {"x":50,"y":50,"page":1} |
            | Formats de signature | Automatique        | NONE     | AUTO            | Montpellier       | 34000            | true              | {"x":50,"y":50,"page":1} |
            | Formats de signature | CAdES              | NONE     | PKCS7           |                   |                  | false             | {}                       |
            | Formats de signature | HELIOS - XAdES env | HELIOS   | PES_V2          | Montpellier       | 34000            | false             | {}                       |
            | Formats de signature | PAdES              | NONE     | PADES           | Montpellier       |                  | true              | {"x":50,"y":50,"page":1} |
            | Formats de signature | XAdES det          | NONE     | PES_V2_DETACHED | Montpellier       | 34000            | false             | {}                       |

    Scenario Outline: Create subtype "${name}" for type "${type}" and "${validationWorkflowId}" workflow in "${tenant}"
        * call read('classpath:lib/setup/subtype.create.feature') __row

        Examples:
            | tenant               | type               | name           | validationWorkflowId | sealCertificateId                                  | secureMailServerId |
            | Formats de signature | ACTES - CAdES      | Signature      | Signature            |                                                    |                    |
            | Formats de signature | ACTES - PAdES      | Cachet serveur | Cachet serveur       | Christian Buffin - Default tenant - Cachet serveur |                    |
            | Formats de signature | ACTES - PAdES      | Signature      | Signature            |                                                    |                    |
            | Formats de signature | Automatique        | Signature      | Signature            |                                                    |                    |
            | Formats de signature | CAdES              | Signature      | Signature            |                                                    |                    |
            | Formats de signature | HELIOS - XAdES env | Signature      | Signature            |                                                    |                    |
            | Formats de signature | PAdES              | Cachet serveur | Cachet serveur       | Christian Buffin - Default tenant - Cachet serveur |                    |
            | Formats de signature | PAdES              | Signature      | Signature            |                                                    |                    |
            | Formats de signature | XAdES det          | Signature      | Signature            |                                                    |                    |

    Scenario Outline: Set the signature image for user "${email}"
        * call read('classpath:lib/setup/user.signatureImage.create.feature') __row

        Examples:
            | tenant               | email              | path                                            |
            | Formats de signature | gnacarat@dom.local | classpath:files/images/signature - gnacarat.png |
