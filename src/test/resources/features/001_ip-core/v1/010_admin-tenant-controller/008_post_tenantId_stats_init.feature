@ip-core @api-v1
Feature: POST /api/admin/tenant/{tenantId}/stats/init (Create or recreate a stats entry for the given tenant)

    @permissions @fixme-ip-core
    Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} create or recreate a stats entry for an existing tenant
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.createTemporary()
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/stats/init'
            And header Accept = 'application/json'
        When method POST
        Then status <status>
            And if (<status> === 204) utils.assert("response == ''")

        @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 204    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot create or recreate a stats entry for a non-existing tenant
        * api_v1.auth.login('user', 'password')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/stats/init'
            And header Accept = 'application/json'
        When method POST
        Then status <status>

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            |                  |              |          | 401    |


