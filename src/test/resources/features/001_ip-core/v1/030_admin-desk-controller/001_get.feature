@ip-core @api-v1
Feature: GET /api/v1/admin/tenant/{tenantId}/desk (List desks)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'get the desk list from an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> === 200) utils.assert("$ == schemas.desk.index")
            And if (<status> !== 200) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 200    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'get the desk list from a non-existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/desk'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 403    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @searching
    Scenario Outline: ${scenario.title.searching('TENANT_ADMIN', 'get the desk list from an existing tenant', 200, total, searchTerm, sortBy, asc)}
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
            And param asc = <asc>
            And param sortBy = '<sortBy>'
            And param searchTerm = '<searchTerm>'
        When method GET
        Then status 200
            And match $ == schemas.desk.index
            And match $.total == <total>
            And match $.data[*]['<field>'] == <value>

        Examples:
            | searchTerm  | sortBy | asc!  | total | field | value!                           |
            | foo         | NAME   | false | 0     | name  | []                               |
            | lucide      | NAME   | true  | 1     | name  | [ 'Translucide' ]                |
            | trans       | NAME   | true  | 2     | name  | [ 'Translucide', 'Transparent' ] |
            | TRANS       | NAME   | true  | 2     | name  | [ 'Translucide', 'Transparent' ] |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | searchTerm  | sortBy | asc!  | total | field | value!                           |
            |             | NAME   | false | 2     | name  | [ 'Transparent', 'Translucide' ] |
            | trans       | NAME   | false | 2     | name  | [ 'Transparent', 'Translucide' ] |
            | TRANS       | NAME   | false | 2     | name  | [ 'Transparent', 'Translucide' ] |
            | trànslucidé | NAME   | null  | 2     | name  | [ 'Translucide', 'Transparent' ] |
            | TRÀNSLUCIDÉ | NAME   | null  | 2     | name  | [ 'Translucide', 'Transparent' ] |
