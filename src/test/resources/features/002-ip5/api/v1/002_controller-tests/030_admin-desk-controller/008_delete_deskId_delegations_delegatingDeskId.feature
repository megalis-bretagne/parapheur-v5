@api @ip5 @ip-core @api-v1 @admin-desk-controller
Feature: DELETE /api/v1/admin/tenant/{tenantId}/desk/{deskId}/delegations/{delegatingDeskId} (Remove an active or planned delegation from target Desk)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()
        * def existingDeskId = ip5.api.v1.desk.createTemporary(existingTenantId)
        * def nonExistingDeskId = ip5.api.v1.desk.getNonExistingId()
        * def baseRequestData =
"""
{
    "schedule":{
        "2025-01-01T02:00:00.000Z": true,
        "2025-01-31T02:00:00.000Z": false,
    },
    "substituteDeskId": null,
    "subtypeId": null,
    "typeId": null
}
"""

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'remove an active or planned delegation from target existing desk to an existing desk in an existing tenant', status)}
        # Create a delegation
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def delegatingDeskId = ip5.api.v1.desk.getIdByName(existingTenantId, 'Transparent')
        * copy requestData = baseRequestData
        * set requestData.substituteDeskId = delegatingDeskId

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/delegations'
            And header Accept = 'application/json'
            And request requestData
        When method POST
        Then status 201

        # Try to delete it
        * ip5.api.v1.auth.login('<username>', '<password>')
        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/delegations/' + delegatingDeskId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And if (<status> === 204) ip.utils.assert("response == ''")
            And if (<status> !== 204) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 204    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 204    |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 403    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 403    |
        @fixme-ip5 @issue-todo
        Examples:
            | role             | username     | password | status |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'remove an active or planned delegation from target existing desk to an existing desk in a non-existing tenant', status)}
        # Create a delegation
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def delegatingDeskId = ip5.api.v1.desk.getIdByName(existingTenantId, 'Transparent')
        * copy requestData = baseRequestData
        * set requestData.substituteDeskId = delegatingDeskId

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/delegations'
            And header Accept = 'application/json'
            And request requestData
        When method POST
        Then status 201

        # Try to delete it
        * ip5.api.v1.auth.login('<username>', '<password>')
        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/desk/' + existingDeskId + '/delegations/' + delegatingDeskId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 404    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 404    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 404    |
        @fixme-ip5 @issue-todo
        Examples:
            | role             | username     | password | status |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'remove an active or planned delegation from target existing desk to a non-existing desk in an existing tenant', status)}
        # Try to delete it
        * ip5.api.v1.auth.login('<username>', '<password>')
        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/delegations/' + nonExistingDeskId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And match $ == schemas.error

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
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'remove an active or planned delegation from target non-existing desk to an existing desk in an existing tenant', status)}
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def delegatingDeskId = ip5.api.v1.desk.getIdByName(existingTenantId, 'Transparent')

        * ip5.api.v1.auth.login('<username>', '<password>')
        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + nonExistingDeskId + '/delegations/' + delegatingDeskId
            And header Accept = 'application/json'
        When method DELETE
        Then status <status>
            And match $ == schemas.error

        @fixme-ip5 @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 404    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 403    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 403    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 403    |
            |                  |              |          | 401    |
