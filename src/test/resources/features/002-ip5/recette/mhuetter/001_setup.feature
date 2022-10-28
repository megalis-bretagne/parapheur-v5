@recette @ip5 @mhuetter @setup
Feature: Paramétrage métier "mhuetter" (web-delib 6, webActes 2)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)

    Scenario Outline: Create tenant '${name}'
        * call read('classpath:lib/ip5/api/setup/tenant.create.feature') __row

        Examples:
            | name     |
            | mhuetter |

    Scenario Outline: Create user '${userName}' with role '${privilege}' in '${tenant}'
        * call read('classpath:lib/ip5/api/setup/user.create.feature') __row

        Examples:
            | tenant   | userName            | email                                          | firstName  | lastName | password | privilege | notificationsCronFrequency | complementaryField |
            | mhuetter | emetteur@mhuetter   | emetteur-mhuetter@mailcatchall.libriciel.net   | WebService | Emetteur | a123456  | NONE      | disabled                   |                    |
            | mhuetter | signature1@mhuetter | signature1-mhuetter@mailcatchall.libriciel.net | Elea       | Clarins  | a123456  | NONE      | disabled                   |                    |
            | mhuetter | visa1@mhuetter      | visa1-mhuetter@mailcatchall.libriciel.net      | André      | Prada    | a123456  | NONE      | disabled                   |                    |

    Scenario Outline: Create desk '${name}' in '${tenant}'
        * call read('classpath:lib/ip5/api/setup/desk.create.feature') __row

        Examples:
            | tenant   | name       | owners!                                            | parent! | associated! | permissions!                                                         |
            | mhuetter | Signature1 | ['signature1-mhuetter@mailcatchall.libriciel.net'] | ''      | []          | {'action': true}                                                     |
            | mhuetter | Visa1      | ['visa1-mhuetter@mailcatchall.libriciel.net']      | ''      | []          | {'action': true}                                                     |
            | mhuetter | WebService | ['emetteur-mhuetter@mailcatchall.libriciel.net']   | ''      | []          | {'action': true, 'archiving': true, 'chain': true, 'creation': true} |

    Scenario Outline: Create '${name}' one-step-workflow and associate it to the '${deskName}' desk in '${tenant}'
        * call read('classpath:lib/ip5/api/setup/one-step-workflow.create.feature') __row

        Examples:
            | tenant   | name             | deskName   | type      |
            | mhuetter | Signature simple | Signature1 | SIGNATURE |
            | mhuetter | Visa simple      | Visa1      | VISA      |

    Scenario Outline: Create type '${name}' with '${signatureFormat}' signature format in '${tenant}'
        * call read('classpath:lib/ip5/api/setup/type.create.feature') __row

        Examples:
            | tenant   | name  | protocol | signatureFormat | signatureLocation | signatureZipCode | signatureVisible! | signaturePosition!     |
            | mhuetter | PAdES | NONE     | PADES           | Montpellier       |                  | true              | {'x':0,'y':0,'page':1} |

    Scenario Outline: Create subtype '${name}' for type '${type}' and '${validationWorkflowId}' workflow in '${tenant}'
        * call read('classpath:lib/ip5/api/setup/subtype.create.feature') __row

        Examples:
            | tenant   | type  | name             | multiDocuments! | validationWorkflowId | sealAutomatic! | sealCertificateId | secureMailServerId |
            | mhuetter | PAdES | Signature simple | false           | Signature simple     | null           |                   |                    |
            | mhuetter | PAdES | Visa simple      | false           | Visa simple          | null           |                   |                    |

    Scenario Outline: Set the signature image for user '${email}'
        * call read('classpath:lib/ip5/api/setup/user.signatureImage.create.feature') __row

        Examples:
            | tenant   | email                                          | path                                                       |
            | mhuetter | signature1-mhuetter@mailcatchall.libriciel.net | classpath:files/images/signature - signature1-mhuetter.png |
