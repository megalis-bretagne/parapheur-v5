@ip-core @api-v1
Feature: PUT /api/v1/admin/tenant/{tenantId}/user/{userId}/password (Update user password)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def existingUserId = api_v1.user.getIdByEmail(existingTenantId, 'ltransparent@dom.local')
        * def nonExistingUserId = api_v1.user.getNonExistingId()

    @permissions @fixme-ip-core
    Scenario Outline: ${scenario.title.permissions(role, 'update the password of an existing user from an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/password'
            And header Accept = 'application/json'
            And request { password: 'a123456' }
        When method PUT
        Then status <status>
            And if (<status> === 200) utils.assert("response == ''")
            And if (<status> !== 200) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 200    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions @fixme-ip-core
    Scenario Outline: ${scenario.title.permissions(role, 'update the password of a non-existing user from an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + nonExistingUserId + '/password'
            And header Accept = 'application/json'
            And request { password: 'a123456' }
        When method PUT
        Then status <status>
            And match $ == schemas.error

        @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 403    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'update the password of an existing user from a non-existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/user/' + existingUserId + '/password'
            And header Accept = 'application/json'
            And request { password: 'a123456' }
        When method PUT
        Then status <status>
            And match $ == schemas.error

        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 403    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions @fixme-ip-core
    Scenario Outline: ${scenario.title.permissions(role, 'update the password of a non-existing user from a non-existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + nonExistingUserId + '/password'
            And header Accept = 'application/json'
            And request { password: 'a123456' }
        When method PUT
        Then status <status>
            And match $ == schemas.error

        @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 403    |
        @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @data-validation
    Scenario Outline: ${scenario.title.validation('TENANT_ADMIN', 'update the password of an existing user from an existing tenant', status, data)}
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/password'
            And header Accept = 'application/json'
            And request { <field>: <value> }

        When method PUT
        Then status <status>
            And if (<status> === 200) utils.assert("response == ''")
            And if (<status> !== 200) utils.assert("$ == schemas.error")

        Examples:
            | status | field    | value!    | data                |
            | 200    | password | 'a123456' | a correct password  |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | status | field    | value!    | data                |
            | 400    | password | ''        | an empty password   |
            | 400    | password | ' '       | a space as password |
