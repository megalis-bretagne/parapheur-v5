@ip-core @api-v1 @admin-tenant-controller
Feature: DELETE /api/v1/admin/tenant/{tenantId}/stats/remove (Disable stats for the given tenant, and delete every stats entries associated with)

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'disable and delete stats for an existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.createTemporary()

        * api_v1.auth.login('<username>', '<password>')
        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/stats/remove'
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And if (<status> === 204) utils.assert("response == ''")
            And if (<status> !== 204) utils.assert("$ == schemas.error")
        # @fixme: 400 Request Header Or Cookie Too Large ?
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 204    |
            | TENANT_ADMIN     | vgris        | a123456  | 403    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'disable and delete stats for a non-existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

        * api_v1.auth.login('<username>', '<password>')
        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/stats/remove'
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 403    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |
