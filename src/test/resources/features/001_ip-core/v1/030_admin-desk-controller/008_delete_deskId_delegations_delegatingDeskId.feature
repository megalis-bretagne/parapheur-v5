@ip-core @api-v1 @admin-desk-controller
Feature: DELETE /api/v1/admin/tenant/{tenantId}/desk/{deskId}/delegations/{delegatingDeskId} (Remove an active or planned delegation from target Desk)

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
    Scenario Outline: ${scenario.title.permissions(role, 'remove an active or planned delegation from target existing desk to an existing desk in an existing tenant', status)}
        # Create a delegation
        * api_v1.auth.login('user', 'password')
        * def delegatingDeskId = api_v1.desk.getIdByName(existingTenantId, 'Transparent')
        * copy requestData = baseRequestData
        * set requestData.substituteDeskId = delegatingDeskId

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/delegations'
            And header Accept = 'application/json'
            And request requestData
        When method POST
        Then status 201

        # Try to delete it
        * api_v1.auth.login('<username>', '<password>')
        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/delegations/' + delegatingDeskId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And if (<status> === 204) utils.assert("response == ''")
            And if (<status> !== 204) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 204    |
            | TENANT_ADMIN     | vgris        | a123456  | 204    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'remove an active or planned delegation from target existing desk to an existing desk in a non-existing tenant', status)}
        # Create a delegation
        * api_v1.auth.login('user', 'password')
        * def delegatingDeskId = api_v1.desk.getIdByName(existingTenantId, 'Transparent')
        * copy requestData = baseRequestData
        * set requestData.substituteDeskId = delegatingDeskId

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/delegations'
            And header Accept = 'application/json'
            And request requestData
        When method POST
        Then status 201

        # Try to delete it
        * api_v1.auth.login('<username>', '<password>')
        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/desk/' + existingDeskId + '/delegations/' + delegatingDeskId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'remove an active or planned delegation from target existing desk to a non-existing desk in an existing tenant', status)}
        # Try to delete it
        * api_v1.auth.login('<username>', '<password>')
        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/delegations/' + nonExistingDeskId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
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
    Scenario Outline: ${scenario.title.permissions(role, 'remove an active or planned delegation from target non-existing desk to an existing desk in an existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def delegatingDeskId = api_v1.desk.getIdByName(existingTenantId, 'Transparent')

        * api_v1.auth.login('<username>', '<password>')
        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + nonExistingDeskId + '/delegations/' + delegatingDeskId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 403    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |
