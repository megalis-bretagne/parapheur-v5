@api @ip5 @ip-core @api-v1 @admin-user-controller
Feature: DELETE /api/v1/admin/tenant/{tenantId}/user/{userId} (Delete user)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()
        * def existingUserId = ip5.api.v1.user.createTemporary(existingTenantId)
        * def nonExistingUserId = ip5.api.v1.user.getNonExistingId()
        * def userData = ip5.api.v1.user.getById(existingTenantId, existingUserId)

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'delete an existing user from an existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And if (<status> === 204) ip.utils.assert("response == ''")
            And if (<status> !== 204) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456a123456  | 204    |
            | TENANT_ADMIN     | vgris        | a123456a123456  | 204    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456a123456  | 403    |
            | NONE             | ltransparent | a123456a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'delete an existing user from a non-existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456a123456  | 404    |
            | NONE             | ltransparent | a123456a123456  | 404    |
            |                  |              |          | 404    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'delete a non-existing user from an existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And match $ == schemas.error

        @fixme-ip5 @issue-ip-core-78 @issue-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456a123456  | 404    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456a123456  | 403    |
            | NONE             | ltransparent | a123456a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'delete a non-existing user from a non-existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456a123456  | 404    |
            | NONE             | ltransparent | a123456a123456  | 404    |
            |                  |              |          | 404    |
