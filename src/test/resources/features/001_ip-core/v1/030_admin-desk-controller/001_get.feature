@ip-core @api-v1
Feature: GET /api/admin/tenant/{tenantId}/desk (List desks)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()

    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} get the list from an existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
        When method GET
        Then status <status>
            And if (<status> === 200) karate.match("$ == schemas.desk.index")
            And if (<status> === 200) karate.match("$.total == 2")
            And if (<status> === 200) karate.match("$.data[*].name == [ 'Translucide', 'Transparent' ]")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 200    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot get the list from a non-existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/desk'
            And header Accept = 'application/json'
        When method GET
        Then status <status>

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
            |                  |              |          | 401    |

    @searching
    Scenario Outline: Searching - a user with an "ADMIN" role can filter the desk list and get ${total} result(s) with "${searchTerm}", sorted by ${sortBy}, ${asc ? 'ascending' : 'descending'}
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk'
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
            | searchTerm | sortBy | asc   | total | field | value!                           |
            | foo        | NAME   | false | 0     | name  | []                               |
            | lucide     | NAME   | true  | 1     | name  | [ 'Translucide' ]                |
            | trans      | NAME   | true  | 2     | name  | [ 'Translucide', 'Transparent' ] |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | searchTerm | sortBy | asc   | total | field | value!                           |
            | trans      | NAME   | false | 2     | name  | [ 'Transparent', 'Translucide' ] |
