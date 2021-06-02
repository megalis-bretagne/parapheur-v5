@ip-core @api-v1
Feature: GET /api/v1/admin/tenant/{tenantId}/desk/{deskId}/users (List users from desk)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def existingDeskId = api_v1.desk.getIdByName(existingTenantId, 'Transparent')
        * def nonExistingDeskId = api_v1.desk.getNonExistingId()
        # @todo: export those schemas in JSON files
        * def schemaElement =
"""
{
    "lastName": "#string",
    "isLdapSynchronized": "#boolean",
    "complementaryField": null,
    "rolesCount": "#number",
    "privilege": "##regex (ADMIN|FUNCTIONAL_ADMIN|NONE)",
    "userName": "#string",
    "isChecked": "#boolean",
    "firstName": "#string",
    "notificationsRedirectionMail": null,
    "isLocked": "##boolean",
    "notificationsCronFrequency": null,
    "signatureImageContentId": null,
    "id":"#uuid",
    "email":"#string"
}
"""
        * def schemaIndex =
"""
{
    "total": "#number",
    "data": "#[] #(schemaElement)",
    "pageSize": "#number",
    "page": "#number"
}
"""

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'list users from an existing desk in an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
          And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/users'
          And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> === 200) utils.assert("$ == schemaIndex")
            And if (<status> !== 200) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 200    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'list users from an existing desk in a non-existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
          And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/desk/' + existingDeskId + '/users'
          And header Accept = 'application/json'
        When method GET
        Then status <status>
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'list users from a non-existing desk in an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
          And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + nonExistingDeskId + '/users'
          And header Accept = 'application/json'
        When method GET
        Then status <status>
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'list users from a non-existing desk in a non-existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
          And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + nonExistingDeskId + '/users'
          And header Accept = 'application/json'
        When method GET
        Then status <status>
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |
