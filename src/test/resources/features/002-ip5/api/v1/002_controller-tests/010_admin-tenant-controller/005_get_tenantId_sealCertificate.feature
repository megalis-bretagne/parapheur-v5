@api @ip5 @ip-core @api-v1 @admin-tenant-controller
Feature: GET /api/v1/admin/tenant/{tenantId}/sealCertificate (List seal certificates)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'get the seal certificates list of an existing tenant', status)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/sealCertificate'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> == 200) ip.utils.assert("$ == schemas.sealCertificate.index")
            And if (<status> == 200) ip.utils.assert("$.total == 1")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 200    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 200    |
        @fixme-ip5 @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 403    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'get the seal certificates list of a non-existing tenant', status)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/sealCertificate'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 404    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 404    |
        @fixme-ip5 @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 403    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 403    |
            |                  |              |          | 401    |
