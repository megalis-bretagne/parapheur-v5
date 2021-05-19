@ip-core @api-v1
Feature: DELETE /api/admin/tenant/{tenantId}/stats/remove (Disable stats for the given tenant, and delete every stats entries associated with)

    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} disable and delete stats for an existing tenant
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.createTemporary()

        * api_v1.auth.login('<username>', '<password>')
        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/stats/remove'
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 204    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} cannot disable and delete stats for a non-existing tenant
        * api_v1.auth.login('user', 'password')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

        * api_v1.auth.login('<username>', '<password>')
        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/stats/remove'
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            |                  |              |          | 401    |
