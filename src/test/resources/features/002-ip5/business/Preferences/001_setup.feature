@business @ip5 @preferences @setup
Feature: Paramétrage métier "Préférences"

  Background:
    * ip5.api.v1.auth.login('user', adminUserPwd)

  Scenario Outline: Create tenant "${name}"
    * call read('classpath:lib/ip5/api/setup/tenant.create.feature') __row

    Examples:
      | name        |
      | Préférences |

  Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
    * call read('classpath:lib/ip5/api/setup/user.create.feature') __row

    Examples:
      | tenant      | userName       | email                    | firstName | lastName | password | privilege | notificationsCronFrequency |
      | Préférences | kpapin         | kpapin@dom.local         | Kali      | Papin    | a123456  | NONE      | disabled                   |
      | Préférences | ws-preferences | ws-preferences@dom.local | Service   | Web      | a123456  | NONE      | disabled                   |

  Scenario Outline: Create desk "${name}" in "${tenant}"
    * call read('classpath:lib/ip5/api/setup/desk.create.feature') __row

    Examples:
      | tenant      | name       | owners!                      | parent! | associated! | permissions!                                                         |
      | Préférences | Kali_01    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
      | Préférences | Kali_02    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
      | Préférences | Kali_03    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
      | Préférences | Kali_04    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
      | Préférences | Kali_05    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
      | Préférences | Kali_06    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
      | Préférences | Kali_07    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
      | Préférences | Kali_08    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
      | Préférences | Kali_09    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
      | Préférences | Kali_10    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
      | Préférences | Kali_11    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
      | Préférences | Kali_12    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
      | Préférences | Kali_13    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
      | Préférences | Kali_14    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
      | Préférences | Kali_15    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
#      | Préférences | Kali_16    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
#      | Préférences | Kali_17    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
#      | Préférences | Kali_18    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
#      | Préférences | Kali_19    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
#      | Préférences | Kali_20    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
#      | Préférences | Kali_21    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
#      | Préférences | Kali_22    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
#      | Préférences | Kali_23    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
#      | Préférences | Kali_24    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
#      | Préférences | Kali_25    | ['kpapin@dom.local']         | ''      | []          | {'action': true}                                                     |
      | Préférences | WebService | ['ws-preferences@dom.local'] | ''      | []          | {'action': true, 'archiving': true, 'chain': true, 'creation': true} |

  Scenario Outline: Create "${name}" one-step-workflow and associate it to the "${deskName}" desk in "${tenant}"
    * call read('classpath:lib/ip5/api/setup/one-step-workflow.create.feature') __row

    Examples:
      | tenant      | name        | deskName | type | mandatoryValidationMetadata! | mandatoryRejectionMetadata! |
      | Préférences | VISA simple | Kali_01  | VISA | []                           | []                          |

  Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
    * call read('classpath:lib/ip5/api/setup/type.create.feature') __row

    Examples:
      | tenant      | name               | protocol | signatureFormat | signatureLocation | signatureZipCode | signatureVisible! | signaturePosition!     |
      | Préférences | ACTES - CAdES      | ACTES    | PKCS7           |                   |                  | false             | {}                     |
      | Préférences | ACTES - PAdES      | ACTES    | PADES           | Montpellier       |                  | true              | {"x":0,"y":0,"page":1} |
      | Préférences | Automatique        | NONE     | AUTO            | Montpellier       | 34000            | true              | {"x":0,"y":0,"page":1} |
      | Préférences | CAdES              | NONE     | PKCS7           |                   |                  | false             | {}                     |
      | Préférences | HELIOS - XAdES env | HELIOS   | PES_V2          | Montpellier       | 34000            | false             | {}                     |
      | Préférences | PAdES              | NONE     | PADES           | Montpellier       |                  | true              | {"x":0,"y":0,"page":1} |
      | Préférences | XAdES det          | NONE     | XADES_DETACHED  | Montpellier       | 34000            | false             | {}                     |

  Scenario Outline: Create subtype "${name}" for type "${type}" and "${validationWorkflowId}" workflow in "${tenant}"
    * call read('classpath:lib/ip5/api/setup/subtype.create.feature') __row

    Examples:
      | tenant      | type               | name                           | multiDocuments! | validationWorkflowId | sealAutomatic! | sealCertificateId | secureMailServerId |
      | Préférences | ACTES - CAdES      | VISA simple ACTES - CAdES      | false           | VISA simple          | null           |                   |                    |
      | Préférences | ACTES - PAdES      | VISA simple ACTES - PAdES      | false           | VISA simple          | null           |                   |                    |
      | Préférences | Automatique        | VISA simple Automatique        | false           | VISA simple          | null           |                   |                    |
      | Préférences | CAdES              | VISA simple CAdES              | false           | VISA simple          | null           |                   |                    |
      | Préférences | HELIOS - XAdES env | VISA simple HELIOS - XAdES env | false           | VISA simple          | null           |                   |                    |
      | Préférences | PAdES              | VISA simple PAdES              | false           | VISA simple          | null           |                   |                    |
      | Préférences | XAdES det          | VISA simple XAdES det          | false           | VISA simple          | null           |                   |                    |
