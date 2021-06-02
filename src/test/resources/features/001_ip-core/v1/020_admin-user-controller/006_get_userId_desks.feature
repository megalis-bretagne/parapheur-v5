@ip-core @api-v1
Feature: GET /api/v1/admin/tenant/{tenantId}/user/{userId}/desks (Get a single user's desks)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def nonExistingUserId = api_v1.user.getNonExistingId()

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'get an existing single user\'s desks from an existing tenant', status)}
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, '<email>')
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/desks'
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
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | ltransparent@dom.local | 403    |                   |
            | NONE             | ltransparent | a123456  | ltransparent@dom.local | 403    |                   |
            |                  |              |          | ltransparent@dom.local | 401    |                   |

    @permissions @fixme-ip-core
    Scenario Outline: ${scenario.title.permissions(role, 'get a non-existing single user\'s desks from an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + nonExistingUserId + '/desks'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And match $ == schemas.error

        @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions @fixme-ip-core
    Scenario Outline: ${scenario.title.permissions(role, 'get an existing single user\'s desks from a non-existing tenant', status)}
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, 'sample-user@dom.local')
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/user/' + existingUserId + '/desks'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And match $ == schemas.error

        @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions @fixme-ip-core
    Scenario Outline: ${scenario.title.permissions(role, 'get a non-existing single user\'s desks from non-existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/user/' + nonExistingUserId + '/desks'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And match $ == schemas.error

        @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |
