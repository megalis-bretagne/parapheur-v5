@api @ip5 @ip-core @api-v1 @admin-tenant-controller
Feature: POST /api/v1/admin/tenant/{tenantId}/stats/init (Create or recreate a stats entry for the given tenant)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'create or recreate a stats entry for an existing tenant', status)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def existingTenantId = ip5.api.v1.entity.createTemporary()
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/stats/init'
            And header Accept = 'application/json'
        When method POST
        Then status <status>
            And if (<status> === 200) ip.utils.assert("response == ''")
            And if (<status> !== 200) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 200    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 403    |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 403    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'create or recreate a stats entry for a non-existing tenant', status)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()

        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/stats/init'
            And header Accept = 'application/json'
        When method POST
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 404    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 404    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 404    |
            |                  |              |          | 404    |
