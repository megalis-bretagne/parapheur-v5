@ip-core @api-v1
Feature: PUT /api/admin/tenant/{tenantId}/user/{userId}/password (Update user password)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, 'ltransparent@dom.local')
        * def nonExistingUserId = api_v1.user.getNonExistingId()

    @permissions @fixme-ip-core
    Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} update the password of an existing user from an existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/password'
            And header Accept = 'application/json'
            And request { password: 'a123456' }
        When method PUT
        Then status <status>

        @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 200    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions @fixme-ip-core
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot update the password of a non-existing user from an existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/' + existingTenantId + '/user/' + nonExistingUserId + '/password'
            And header Accept = 'application/json'
            And request { password: 'a123456' }
        When method PUT
        Then status <status>

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

    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot update the password of an existing user from a non-existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/' + nonExistingTenantId + '/user/' + existingUserId + '/password'
            And header Accept = 'application/json'
            And request { password: 'a123456' }
        When method PUT
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

    @permissions @fixme-ip-core
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot update the password of a non-existing user from a non-existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/' + existingTenantId + '/user/' + nonExistingUserId + '/password'
            And header Accept = 'application/json'
            And request { password: 'a123456' }
        When method PUT
        Then status <status>

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
