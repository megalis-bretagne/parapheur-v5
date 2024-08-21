@api @ip5 @ip-core @api-v1 @admin-desk-controller
Feature: GET /api/v1/admin/tenant/{tenantId}/desk/{deskId}/users (List users from desk)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()
        * def existingDeskId = ip5.api.v1.desk.getIdByName(existingTenantId, 'Transparent')
        * def nonExistingDeskId = ip5.api.v1.desk.getNonExistingId()
        # @todo: export those schemas in JSON files
        * def schemaElement =
"""
{
    "lastName": "##string",
    "isLdapSynchronized": "#boolean",
    "complementaryField": null,
    "rolesCount": "#number",
    "privilege": "##regex (ADMIN|FUNCTIONAL_ADMIN|NONE|TENANT_ADMIN)",
    "userName": "#string",
    "isChecked": "#boolean",
    "firstName": "##string",
    "notificationsRedirectionMail": null,
    "isLocked": "##boolean",
    "notificationsCronFrequency": "##string",
    "signatureImageContentId": "##string",
    "id":"#uuid",
    "email":"##string",
    "administeredDesks": "##[]",
    "administeredTenants": "##[]",
    "supervisedDesks": "##[]"
}
"""
        * def schemaIndex =
"""
{
    "total": "#number",
    "data": "#[] #(schemaElement)",
    "size": "#number",
    "page": "#number"
}
"""

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'list users from an existing desk in an existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
          And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/users'
          And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> === 200) ip.utils.assert("$ == schemaIndex")
            And if (<status> !== 200) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 200    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 200    |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 403    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'list users from an existing desk in a non-existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
          And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/desk/' + existingDeskId + '/users'
          And header Accept = 'application/json'
        When method GET
        Then status <status>
            And match $ == schemas.error

        @fixme-ip5 @issue-ip-core-78 @issue-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 404    |
        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 404    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 404    |
            |                  |              |          | 404    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'list users from a non-existing desk in an existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
          And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + nonExistingDeskId + '/users'
          And header Accept = 'application/json'
        When method GET
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
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'list users from a non-existing desk in a non-existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
          And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + nonExistingDeskId + '/users'
          And header Accept = 'application/json'
        When method GET
        Then status <status>
            And match $ == schemas.error

        @fixme-ip5 @issue-ip-core-78 @issue-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 404    |
            | TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 403    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 403    |
            | NONE             | ltransparent | Ilenfautpeupouretreheureux  | 403    |
            |                  |              |          | 401    |
