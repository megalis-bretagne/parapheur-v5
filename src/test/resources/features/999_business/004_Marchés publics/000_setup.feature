@business @marchés-publics @proposal @setup
Feature: Paramétrage métier "Marchés publics"
    Background:
        * api_v1.auth.login('user', 'password')

    Scenario Outline: Create tenant "${name}"
        * call read('classpath:lib/setup/tenant.create.feature') __row

        Examples:
            | name            |
            | Marchés publics |

    Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
        * call read('classpath:lib/setup/user.create.feature') __row

        Examples:
            | tenant         | userName   | email                | firstName | lastName  | password | privilege | notificationsCronFrequency |
            | Default tenant | ncorail    | ncorail@dom.local    | Nicolas   | Corail    | a123456  | NONE      | disabled                   |
            | Default tenant | sorange    | sorange@dom.local    | Stéphanie | Orange    | a123456  | NONE      | disabled                   |
            | Default tenant | smandarine | smandarine@dom.local | Sabrina   | Mandarine | a123456  | NONE      | disabled                   |
            | Default tenant | vsafran    | vsafran@dom.local    | Vincent   | Safran    | a123456  | NONE      | disabled                   |
            | Default tenant | ws-mp      | ws-mp@dom.local      | Service   | Web       | a123456  | NONE      | disabled                   |

    Scenario Outline: Associate user "${email}" with tenant "${tenant}"
        * call read('classpath:lib/setup/tenant.user.associate.feature') __row

        Examples:
            | email                | tenant          |
            | ncorail@dom.local    | Marchés publics |
            | sorange@dom.local    | Marchés publics |
            | smandarine@dom.local | Marchés publics |
            | vsafran@dom.local    | Marchés publics |
            | ws-mp@dom.local      | Marchés publics |

    Scenario Outline: Create desk "${name}" in "${tenant}"
        * call read('classpath:lib/setup/desk.create.feature') __row

        Examples:
            | tenant          | name       | owners!                  | parent!     | associated! | permissions!                                       |
            | Marchés publics | Corail     | ['ncorail@dom.local']    | ''          | []          | {'action': true, 'archiving': true, 'chain': true} |
            | Marchés publics | Orange     | ['sorange@dom.local']    | 'Corail'    | []          | {'action': true, 'archiving': true, 'chain': true} |
            | Marchés publics | Mandarine  | ['smandarine@dom.local'] | 'Orange'    | []          | {'action': true, 'archiving': true, 'chain': true} |
            | Marchés publics | Safran     | ['vsafran@dom.local']    | 'Mandarine' | []          | {'action': true, 'archiving': true, 'chain': true} |
            | Marchés publics | WebService | ['ws-mp@dom.local']      | ''          | []          | {'action': true, 'creation': true}                 |

    Scenario: Create a 4 steps workflow, 3 first steps are VISA, fourth step is a signature, first validator is "Safran", other validators are "Boss of"
        * def tenantId = api_v1.entity.getIdByName('Marchés publics')
        * def safranDeskId = api_v1.desk.getIdByName(tenantId, 'Safran')
        * def payload =
"""
{
    "steps":[
        {"validators":["#(safranDeskId)"],"validationMode":"SIMPLE","name":"VISA","type":"VISA","parallelType":"OR"},
        {"validators":["##BOSS_OF##"],"validationMode":"SIMPLE","name":"VISA","type":"VISA","parallelType":"OR"},
        {"validators":["##BOSS_OF##"],"validationMode":"SIMPLE","name":"VISA","type":"VISA","parallelType":"OR"},
        {"validators":["##BOSS_OF##"],"validationMode":"SIMPLE","name":"SIGNATURE","type":"SIGNATURE","parallelType":"OR"}
    ],
    "name":"Validation et signature",
    "id":"validation_et_signature",
    "key":"validation_et_signature",
    "deploymentId":"validation_et_signature"
}
"""
        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And request payload
        When method POST
        Then status 201

    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * call read('classpath:lib/setup/type.create.feature') __row

        Examples:
            | tenant          | name          | description   | protocol | signatureFormat | signatureLocation | signatureZipCode | signaturePosition! | workflowSelectionScript! |
            | Marchés publics | Marché public | Marché public |          | PADES           | Montpellier       |                  |                    | ''                       |

    Scenario Outline: Create subtype "${name}" for type "${type}" and "${workflow}" workflow in "${tenant}"
        * call read('classpath:lib/setup/subtype.create.feature') __row

        Examples:
            | tenant          | type          | name         | description  | workflow!                 | sealCertificate! | workflowSelectionScript! | subtypeMetadataRequestList! |
            | Marchés publics | Marché public | Service fait | Service fait | 'Validation et signature' | ''               | ''                       | []                          |

    Scenario Outline: Set the signature image for user "${email}"
        * call read('classpath:lib/setup/user.signatureImage.create.feature') __row

        Examples:
            | tenant          | email             | path                                           |
            | Marchés publics | ncorail@dom.local | classpath:files/images/signature - ncorail.png |
