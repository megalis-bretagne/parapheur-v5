@api @ip5 @ip-core @api-v1 @admin-tenant-controller
Feature: DELETE /api/v1/admin/tenant/{tenantId}/stats/remove (Disable stats for the given tenant, and delete every stats entries associated with)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'disable and delete stats for an existing tenant', status)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        # @fixme: 400 Request Header Or Cookie Too Large ?
        * def existingTenantId = ip5.api.v1.entity.createTemporary()

        * ip5.api.v1.auth.login('<username>', '<password>')
        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/stats/remove'
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And if (<status> === 204) ip.utils.assert("response == ''")
            And if (<status> !== 204) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456a123456  | 204    |
            | TENANT_ADMIN     | vgris        | a123456a123456  | 403    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456a123456  | 403    |
            | NONE             | ltransparent | a123456a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'disable and delete stats for a non-existing tenant', status)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()

        * ip5.api.v1.auth.login('<username>', '<password>')
        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/stats/remove'
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
