@api @ip5 @ip-core @api-v1 @admin-user-controller
Feature: GET /api/v1/admin/tenant/{tenantId}/user/{userId}/desks (Get a single user's desks)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()
        * def nonExistingUserId = ip5.api.v1.user.getNonExistingId()

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'get an existing single user\'s desks from an existing tenant', status)}
        * def existingUserId = ip5.api.v1.user.getIdByEmail(existingTenantId, '<email>')
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + existingUserId + '/desks'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> === 200) ip.utils.assert("$ == schemas.desk.index")
            And if (<status> === 200) ip.utils.assert("$.data[*].name == <name>")

        Examples:
            | role             | username     | password | email                  | status | name!             |
            | ADMIN            | cnoir        | a123456  | ne-pas-repondre@dom.local  | 200    | []                |
            | ADMIN            | cnoir        | a123456  | ltransparent@dom.local | 200    | [ 'Transparent' ] |
            | TENANT_ADMIN     | vgris        | a123456  | ltransparent@dom.local | 200    | [ 'Transparent' ] |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | ltransparent@dom.local | 403    |                   |
            | NONE             | ltransparent | a123456  | ltransparent@dom.local | 403    |                   |
            |                  |              |          | ltransparent@dom.local | 401    |                   |

    @permissions @fixme-ip5
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'get a non-existing single user\'s desks from an existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/user/' + nonExistingUserId + '/desks'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        @issue-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions @fixme-ip5
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'get an existing single user\'s desks from a non-existing tenant', status)}
        * def existingUserId = ip5.api.v1.user.getIdByEmail(existingTenantId, 'ne-pas-repondre@dom.local')
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/user/' + existingUserId + '/desks'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 403    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions @fixme-ip5
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'get a non-existing single user\'s desks from non-existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/user/' + nonExistingUserId + '/desks'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 403    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |
