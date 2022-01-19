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

#Scenario Outline: Create "${name}" one-step-workflow and associate it to the "${deskName}" desk in "${tenant}"
#* call read('classpath:lib/setup/one-step-workflow.create.feature') __row
#
#Examples:
#| tenant  | name      | deskName | type      |
#| SOLUDOC | Signature | Maire    | SIGNATURE |
#
#Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
#* call read('classpath:lib/setup/type.create.feature') __row
#
#Examples:
#| tenant  | name          | description                        | protocol | signatureFormat | signatureLocation | signatureZipCode | signaturePosition!       | workflowSelectionScript! |
#| SOLUDOC | ACTES - CAdES | Signature CAdES (ACTES)            | ACTES    | PKCS7           |                   |                  |                          | ''                       |
#| SOLUDOC | ACTES - PAdES | Signature PAdES (ACTES)            | ACTES    | PADES           | Montpellier       |                  | {"x":50,"y":50,"page":1} | ''                       |
#| SOLUDOC | HELIOS        | Signature XAdES enveloppé (HELIOS) | HELIOS   | PES_V2          | Montpellier       | 34000            |                          | ''                       |
#
#Scenario Outline: Create subtype "${name}" for type "${type}" and "${workflow}" workflow in "${tenant}"
#* call read('classpath:lib/setup/subtype.create.feature') __row
#
#Examples:
#| tenant  | type          | name                    | description                     | workflow!   | sealCertificate! | workflowSelectionScript! | subtypeMetadataRequestList! |
#| SOLUDOC | ACTES - CAdES | ACTES - CAdES - Monodoc | Signature CAdES monodoc (ACTES) | 'Signature' | ''               | ''                       | []                          |
#| SOLUDOC | ACTES - PAdES | ACTES - PAdES - Monodoc | Signature PAdES monodoc (ACTES) | 'Signature' | ''               | ''                       | []                          |
#| SOLUDOC | HELIOS        | HELIOS - Monodoc        | Signature HELIOS monodoc        | 'Signature' | ''               | ''                       | []                          |
#
#Scenario Outline: Set the signature image for user "${email}"
#* call read('classpath:lib/setup/user.signatureImage.create.feature') __row
#
#Examples:
#| tenant  | email            | path                                          |
#| SOLUDOC | kmauve@dom.local | classpath:files/images/signature - kmauve.png |
