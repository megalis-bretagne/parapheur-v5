@before
Feature: Typology setup

  Background:
    * ip5.api.v1.auth.login('user', adminUserPwd)

  Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
    * call read('classpath:lib/ip5/api/setup/user.create.feature') __row

    Examples:
      | tenant         | userName       | email          | firstName | lastName | password | privilege | notificationsCronFrequency |
      | Default tenant | kali_01_karate | kali@dom.local | kali      | kali     | a123456  | NONE      | disabled                   |

  Scenario Outline: Associate user "${email}" with tenant "${tenant}"
    * call read('classpath:lib/ip5/api/setup/tenant.user.associate.feature') __row

    Examples:
      | email          | tenant         |
      | kali@dom.local | Default tenant |


  Scenario Outline: Create type "${name}"
    * call read('classpath:lib/ip5/api/setup/type.create.feature') __row

    Examples:
      | tenant         | name                     | description                    | protocol | signatureFormat | signatureLocation | signatureZipCode | signatureVisible! | signaturePosition! |
      | Default tenant | typology_setup_type_name | typology_setup_type_descripton |          | PADES           |                   |                  | false             |                    |

  Scenario Outline: Create desk "${name}" in "${tenant}"
    * call read('classpath:lib/ip5/api/setup/desk.create.feature') __row

    Examples:
      | tenant         | name                     | owners!            | parent! | associated! | permissions!                                       |
      | Default tenant | typology_setup_desk_name | ['kali@dom.local'] | ''      | []          | {'action': true, 'archiving': true, 'chain': true} |

  Scenario Outline: Create "${name}" one-step-workflow
    * call read('classpath:lib/ip5/api/setup/one-step-workflow.create.feature') __row

    Examples:
      | tenant         | name                    | deskName                 | type |
      | Default tenant | typology_setup_workflow | typology_setup_desk_name | VISA |


  Scenario Outline: Create subtype "${name}" for type "${type}" and "${validationWorkflowId}" workflow in "${tenant}"
    * call read('classpath:lib/ip5/api/setup/subtype.create.feature') __row

    Examples:
      | tenant         | type                     | name                        | description                        | validationWorkflowId    | secureMailServerId | sealCertificateId | workflowSelectionScript! | subtypeMetadataList! |
      | Default tenant | typology_setup_type_name | typology_setup_subtype_name | typology_setup_subtype_description | typology_setup_workflow |                    |                   | ''                       | []                   |
