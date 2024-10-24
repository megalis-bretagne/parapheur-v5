@api @ip5 @ip-core @api-v1 @admin-desk-controller
Feature: DELETE /api/v1/admin/tenant/{tenantId}/desk/{deskId} (Delete desk)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()
        * def existingDeskId = ip5.api.v1.desk.createTemporary(existingTenantId)
        * def nonExistingDeskId = ip5.api.v1.desk.getNonExistingId()
        * def deskData = ip5.api.v1.desk.getById(existingTenantId, existingDeskId)

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'delete an existing desk from an existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/provisioning/v1/admin/tenant/', existingTenantId, '/desk/', existingDeskId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 204    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 204    |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 403    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'delete an existing desk from a non-existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/provisioning/v1/admin/tenant/', nonExistingTenantId, '/desk/', existingDeskId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 404    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 404    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 404    |
            |                  |              |          | 404    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'delete a non-existing desk from an existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/provisioning/v1/admin/tenant/', existingTenantId, '/desk/', nonExistingDeskId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>

        @fixme-ip5 @issue-ip-core-78 @issue-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 404    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 404    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 403    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'delete a non-existing desk from a non-existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/provisioning/v1/admin/tenant/', nonExistingTenantId, '/desk/', nonExistingDeskId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 404    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 404    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 404    |
            |                  |              |          | 404    |
