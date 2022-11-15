@api @ip5 @ip-core @api-v1 @admin-desk-controller
Feature: GET /api/v1/admin/tenant/{tenantId}/desk (List desks)

    Background:
        * ip5.api.v1.auth.login('user', adminUserPwd)
        * def list = ip5.api.v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

        * def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
        * def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'get the desk list from an existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> === 200) ip.utils.assert("$ == schemas.desk.index")
            And if (<status> !== 200) ip.utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 200    |
            | TENANT_ADMIN     | vgris        | a123456  | 200    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${ip5.scenario.title.permissions(role, 'get the desk list from a non-existing tenant', status)}
        * ip5.api.v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/desk'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And match $ == schemas.error

        @fixme-ip5 @issue-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 404    |

    @searching
    Scenario Outline: ${ip5.scenario.title.searching('ADMIN', 'get the desk list from an existing tenant', 200, total, searchTerm, sort, direction)}
        * ip5.api.v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
            And param sort = '<sort>,<direction>'
            And param searchTerm = '<searchTerm>'
        When method GET
        Then status 200
            And match $ == schemas.desk.index
            And match $.total == <total>
            And match $.data[*]['<field>'] == <value>

        Examples:
            | searchTerm | sort | direction | total | field | value!                           |
            | foo        | NAME | DESC      | 0     | name  | []                               |
            | lucide     | NAME | ASC       | 1     | name  | [ 'Translucide' ]                |
            | trans      | NAME | ASC       | 2     | name  | [ 'Translucide', 'Transparent' ] |
            | TRANS      | NAME | ASC       | 2     | name  | [ 'Translucide', 'Transparent' ] |
        @fixme-ip5 @issue-todo
        Examples:
            | searchTerm | sort | direction | total | field | value!                           |
            |            | NAME | DESC      | 2     | name  | [ 'Transparent', 'Translucide' ] |
            | trans      | NAME | DESC      | 2     | name  | [ 'Transparent', 'Translucide' ] |
            | TRANS      | NAME | DESC      | 2     | name  | [ 'Transparent', 'Translucide' ] |
