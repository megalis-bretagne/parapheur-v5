@ip-core @api-v1 @admin-desk-controller
Feature: POST /api/v1/admin/tenant/{tenantId}/desk/{deskId}/delegations (Create a new delegation (active or planned) from target desk)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def existingDeskId = api_v1.desk.createTemporary(existingTenantId)
        * def nonExistingDeskId = api_v1.desk.getNonExistingId()
        * def baseRequestData =
"""
{
    "schedule":{
        "2025-01-01T02:00:00.000Z": true,
        "2025-01-31T02:00:00.000Z": false,
    },
    "substituteDeskId": null,
    "subtypeId": null,
    "typeId": null
}
"""

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a new delegation from target existing desk to an existing desk in an existing tenant', status)}
        * def delegatingDeskId = api_v1.desk.getIdByName(existingTenantId, 'Transparent')
        * api_v1.auth.login('<username>', '<password>')
        * copy requestData = baseRequestData
        * set requestData.substituteDeskId = delegatingDeskId

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/delegations'
            And header Accept = 'application/json'
            And request requestData
        When method POST
        Then status <status>
            And if (<status> === 201) utils.assert("response == ''")
            And if (<status> !== 201) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 201    |
            | TENANT_ADMIN     | vgris        | a123456  | 201    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a new delegation from target existing desk to an existing desk in a non-existing tenant', status)}
        * def delegatingDeskId = api_v1.desk.getIdByName(existingTenantId, 'Transparent')
        * api_v1.auth.login('<username>', '<password>')
        * copy requestData = baseRequestData
        * set requestData.substituteDeskId = delegatingDeskId

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/desk/' + existingDeskId + '/delegations'
            And header Accept = 'application/json'
            And request baseRequestData
        When method POST
        Then status <status>
            And utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 404    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a new delegation from target existing desk to a non-existing desk in an existing tenant', status)}
        * def delegatingDeskId = api_v1.desk.getIdByName(existingTenantId, 'Transparent')
        * api_v1.auth.login('<username>', '<password>')
        * copy requestData = baseRequestData
        * set requestData.substituteDeskId = nonExistingDeskId

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/delegations'
            And header Accept = 'application/json'
            And request baseRequestData
        When method POST
        Then status <status>
            And utils.assert("$ == schemas.error")

        @fixme-ip-core
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a new delegation from target non-existing desk to an existing desk in an existing tenant', status)}
        * def delegatingDeskId = api_v1.desk.getIdByName(existingTenantId, 'Transparent')
        * api_v1.auth.login('<username>', '<password>')
        * copy requestData = baseRequestData
        * set requestData.substituteDeskId = delegatingDeskId

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + nonExistingDeskId + '/delegations'
            And header Accept = 'application/json'
            And request baseRequestData
        When method POST
        Then status <status>
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 403    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @data-validation
    Scenario Outline: ${scenario.title.validation('ADMIN', 'create a new delegation from target desk', status, data)}
        * copy requestData = request_data
        * if (field !== '') requestData[field] = utils.eval(value)

        * api_v1.auth.login('cnoir', 'a123456')
        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/delegations'
            And header Accept = 'application/json'
            And request requestData
        When method POST
        Then status <status>
            And if (<status> === 201) utils.assert("response == ''")
            And if (<status> !== 201) utils.assert("$ == schemas.error")

        Examples:
            | status | field!             | value!                                                         | request_data!                                                                                                                                        | data                                           |
            | 201    | 'substituteDeskId' | eval(api_v1.desk.getIdByName(existingTenantId, 'Transparent')) | { "schedule":{ "2025-01-01T02:00:00.000Z": true, "2025-01-31T02:00:00.000Z": false, }, "substituteDeskId": null, "subtypeId": null, "typeId": null } | right data types                               |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | status | field            | value!                                                         | request_data!                                                                                                                                        | data                                           |
            | 400    | ''                 |                                                                | { "foo": true, "bar": false }                                                                                                                        | wrong data types (strings instead of dates)    |
            | 400    | ''                 |                                                                | {}                                                                                                                                                   | an empty request body                          |
            | 400    | ''                 |                                                                | { "schedule":{ "2025-01-01T02:00:00.000Z": 6, "2025-01-31T02:00:00.000Z": 6, }, "substituteDeskId": null, "subtypeId": null, "typeId": null }        | wrong data types (integer instead of booleans) |
