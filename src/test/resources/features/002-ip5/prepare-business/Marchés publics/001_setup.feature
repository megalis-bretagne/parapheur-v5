@prepare-business @ip5 @marchés-publics @setup
Feature: Paramétrage métier "Marchés publics"
    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)

    Scenario Outline: Create tenant "${name}"
        * call read('classpath:lib/ip5/api/setup/tenant.create.feature') __row

        Examples:
            | name            |
            | Marchés publics |

    Scenario Outline: Create user "${userName}" with role "${privilege}" in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/user.create.feature') __row

        Examples:
            | tenant          | userName   | email                | firstName | lastName  | password | privilege | notificationsCronFrequency | administeredDesk |
            | Marchés publics | ncorail    | ncorail@dom.local    | Nicolas   | Corail    | a123456  | NONE      | disabled                   |                  |
            | Marchés publics | sorange    | sorange@dom.local    | Stéphanie | Orange    | a123456  | NONE      | disabled                   |                  |
            | Marchés publics | smandarine | smandarine@dom.local | Sabrina   | Mandarine | a123456  | NONE      | disabled                   |                  |
            | Marchés publics | vsafran    | vsafran@dom.local    | Vincent   | Safran    | a123456  | NONE      | disabled                   |                  |
            | Marchés publics | ws-mp      | ws-mp@dom.local      | Service   | Web       | a123456  | NONE      | disabled                   |                  |

    Scenario Outline: Create desk "${name}" in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/desk.create.feature') __row

        Examples:
            | tenant          | name       | owners!                  | parent!     | associated! | permissions!                                                         |
            | Marchés publics | Corail     | ['ncorail@dom.local']    | ''          | []          | {'action': true}                                                     |
            | Marchés publics | Orange     | ['sorange@dom.local']    | 'Corail'    | []          | {'action': true}                                                     |
            | Marchés publics | Mandarine  | ['smandarine@dom.local'] | 'Orange'    | []          | {'action': true}                                                     |
            | Marchés publics | Safran     | ['vsafran@dom.local']    | 'Mandarine' | []          | {'action': true}                                                     |
            | Marchés publics | WebService | ['ws-mp@dom.local']      | ''          | []          | {'action': true, 'archiving': true, 'chain': true, 'creation': true} |

    Scenario: Create a 4 steps workflow, 3 first steps are VISA, fourth step is a signature, first validator is "Safran", other validators are "Boss of"
        * def tenantId = ip5.api.v1.entity.getIdByName('Marchés publics')
        * def safranDeskId = ip5.api.v1.desk.getIdByName(tenantId, 'Safran')
        * def payload =
"""
{
    "steps":[
        {"validatingDeskIds":["#(safranDeskId)"],"type":"VISA","parallelType":"OR"},
        {"validatingDeskIds":["##BOSS_OF##"],"type":"VISA","parallelType":"OR"},
        {"validatingDeskIds":["##BOSS_OF##"],"type":"VISA","parallelType":"OR"},
        {"validatingDeskIds":["##BOSS_OF##"],"type":"SIGNATURE","parallelType":"OR"}
    ],
    "name":"Validation et signature",
    "id":"validation_et_signature",
    "key":"validation_et_signature",
    "deploymentId":"validation_et_signature",
    "finalDeskId": "##EMITTER##"
}
"""
        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And request payload
        When method POST
        Then status 201

    Scenario Outline: Create type "${name}" with "${signatureFormat}" signature format in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/type.create.feature') __row

        Examples:
            | tenant          | name          | description   | protocol | signatureFormat | signatureLocation | signatureZipCode | signatureVisible! | signaturePosition! | workflowSelectionScript! |
            | Marchés publics | Marché public | Marché public |          | PADES           | Montpellier       |                  | false             |                    | ''                       |

    Scenario Outline: Create subtype "${name}" for type "${type}" and "${validationWorkflowId}" workflow in "${tenant}"
        * call read('classpath:lib/ip5/api/setup/subtype.create.feature') __row

        Examples:
            | tenant          | type          | name         | description  | multiDocuments! | validationWorkflowId    | secureMailServerId | sealCertificateId | workflowSelectionScript! | subtypeMetadataList! |
            | Marchés publics | Marché public | Service fait | Service fait | true            | Validation et signature |                    |                   | ''                       | []                   |

    Scenario Outline: Set the signature image for user "${email}"
        * call read('classpath:lib/ip5/api/setup/user.signatureImage.create.feature') __row

        Examples:
            | tenant          | email             | path                                           |
            | Marchés publics | ncorail@dom.local | classpath:files/images/signature - ncorail.png |
