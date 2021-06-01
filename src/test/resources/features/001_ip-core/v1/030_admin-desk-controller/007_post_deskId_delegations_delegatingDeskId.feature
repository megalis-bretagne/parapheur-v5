@ip-core @api-v1 @666
Feature: POST /api/admin/tenant/{tenantId}/desk/{deskId}/delegations/{delegatingDeskId} (Create a new delegation (active or planned) from target desk)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def existingDeskId = api_v1.desk.createTemporary(existingTenantId)
        * def nonExistingDeskId = api_v1.desk.getNonExistingId()
        * def requestData =
"""
{
    "2025-01-01T02:00:00.000Z": true,
    "2025-01-31T02:00:00.000Z": false,
}
"""

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a new delegation from target existing desk to an existing desk in an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')
        * def delegatingDeskId = api_v1.desk.getIdByName(existingTenantId, 'Transparent')

        Given url baseUrl
            And path '/api/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/delegations/' + delegatingDeskId
            And header Accept = 'application/json'
            And request requestData
        When method POST
        Then status <status>
            And if (<status> === 201) utils.assert("response == ''")
            And if (<status> !== 201) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 201    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a new delegation from target existing desk to an existing desk in a non-existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')
        * def delegatingDeskId = api_v1.desk.getIdByName(existingTenantId, 'Transparent')

        Given url baseUrl
            And path '/api/admin/tenant/' + nonExistingTenantId + '/desk/' + existingDeskId + '/delegations/' + delegatingDeskId
            And header Accept = 'application/json'
            And request requestData
        When method POST
        Then status <status>
            And match $ == schemas.error

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a new delegation from target existing desk to a non-existing desk in an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')
        * def delegatingDeskId = api_v1.desk.getIdByName(existingTenantId, 'Transparent')

        Given url baseUrl
            And path '/api/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/delegations/' + nonExistingDeskId
            And header Accept = 'application/json'
            And request requestData
        When method POST
        Then status <status>
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a new delegation from target non-existing desk to an existing desk in an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')
        * def delegatingDeskId = api_v1.desk.getIdByName(existingTenantId, 'Transparent')

        Given url baseUrl
            And path '/api/admin/tenant/' + existingTenantId + '/desk/' + nonExistingDeskId + '/delegations/' + delegatingDeskId
            And header Accept = 'application/json'
            And request requestData
        When method POST
        Then status <status>
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @data-validation
    Scenario Outline: ${scenario.title.validation('ADMIN', 'create a new delegation from target desk', status, data)}
        * api_v1.auth.login('cnoir', 'a123456')
        * def delegatingDeskId = api_v1.desk.getIdByName(existingTenantId, 'Transparent')

        Given url baseUrl
            And path '/api/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/delegations/' + delegatingDeskId
            And header Accept = 'application/json'
            And request request_data
        When method POST
        Then status <status>
            And if (<status> === 201) utils.assert("response == ''")
            And if (<status> !== 201) utils.assert("$ == schemas.error")

        Examples:
            | status | field | request_data!                                                           | data                                           |
            | 201    | name  | { "2025-01-01T02:00:00.000Z": true, "2025-01-31T02:00:00.000Z": false } | right data types                               |
            | 400    | name  | { "foo": true, "bar": false }                                           | wrong data types (strings instead of dates)    |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | status | field | request_data!                                                           | data                                           |
            | 400    | name  | {}                                                                      | an empty request body                          |
            | 400    | name  | { "2025-01-01T02:00:00.000Z": 6, "2025-01-31T02:00:00.000Z": 6 }        | wrong data types (integer instead of booleans) |
