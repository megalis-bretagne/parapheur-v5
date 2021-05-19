@ip-core @api-v1
Feature: GET /api/admin/tenant/{tenantId}/user/{userId}/desks (Get a single user's desks)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def nonExistingUserId = api_v1.user.getNonExistingId()

    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} get an existing single user's desks from an existing tenant
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, '<email>')
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/desks'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> === 200) utils.assert("$ == schemas.desk.index")
            And if (<status> === 200) utils.assert("$.data[*].name == <name>")

        Examples:
            | role             | username     | password | email                  | status | name!             |
            | ADMIN            | cnoir        | a123456  | sample-user@dom.local  | 200    | []                |
            | ADMIN            | cnoir        | a123456  | ltransparent@dom.local | 200    | [ 'Transparent' ] |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | email                  | status | name!             |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | ltransparent@dom.local | 404    |                   |
            | NONE             | ltransparent | a123456  | ltransparent@dom.local | 404    |                   |
            |                  |              |          | ltransparent@dom.local | 401    |                   |

    @permissions @fixme-ip-core
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot get a non-existing single user's desks from an existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/' + existingTenantId + '/user/' + nonExistingUserId + '/desks'
            And header Accept = 'application/json'
        When method GET
        Then status <status>

        @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 401    |

    @permissions @fixme-ip-core
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot get an existing single user's desks from a non-existing tenant
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, 'sample-user@dom.local')
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/' + nonExistingTenantId + '/user/' + existingUserId + '/desks'
            And header Accept = 'application/json'
        When method GET
        Then status <status>

        @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 401    |

    @permissions @fixme-ip-core
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot get a non-existing single user's desks from non-existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/' + nonExistingTenantId + '/user/' + nonExistingUserId + '/desks'
            And header Accept = 'application/json'
        When method GET
        Then status <status>

        @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 401    |
