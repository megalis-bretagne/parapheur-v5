@ip-core @api-v1
Feature: POST /api/v1/admin/tenant/{tenantId}/stats/init (Create or recreate a stats entry for the given tenant)

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create or recreate a stats entry for an existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.createTemporary()
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/stats/init'
            And header Accept = 'application/json'
        When method POST
        Then status <status>
            And if (<status> === 200) utils.assert("response == ''")
            And if (<status> !== 200) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 200    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create or recreate a stats entry for a non-existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/stats/init'
            And header Accept = 'application/json'
        When method POST
        Then status <status>
            And if (<status> === 200) utils.assert("response == ''")
            And if (<status> !== 200) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |
