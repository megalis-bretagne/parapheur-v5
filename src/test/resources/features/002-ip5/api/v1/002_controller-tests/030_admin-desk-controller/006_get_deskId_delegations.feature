@api @ip5 @ip-core @api-v1 @admin-desk-controller
Feature: GET /api/v1/admin/tenant/{tenantId}/desk/{deskId}/delegations (List delegations (active and planned) for given substitute desk)

    Background:
        * api_v1.auth.login('user', 'password')
        * def list = api_v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def existingDeskId = api_v1.desk.createTemporary(existingTenantId)
        * def nonExistingDeskId = api_v1.desk.getNonExistingId()

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'list delegations for an existing substitute desk in an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + existingDeskId + '/delegations'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> === 200) ip.utils.assert("$ == schemas.delegation.index")
            And if (<status> !== 200) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 200    |
            | TENANT_ADMIN     | vgris        | a123456  | 200    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'list delegations for an existing substitute desk in a non-existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + nonExistingTenantId + '/desk/' + existingDeskId + '/delegations'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And match $ == schemas.error

        @fixme-ip5 @issue-ip-core-78 @issue-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 404    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'list delegations for a non-existing substitute desk in an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + existingTenantId + '/desk/' + nonExistingDeskId + '/delegations'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And match $ == schemas.error

        @fixme-ip5 @issue-ip-core-78 @issue-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |
