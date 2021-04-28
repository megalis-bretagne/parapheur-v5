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
        @fixme-ip-core
        Examples:
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot get the list from a non-existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/desk'
            And header Accept = 'application/json'
        When method GET
        Then status <status>

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @fixme-ip-core
        Examples:
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @searching @todo-karate-better-test-for-sorting
    Scenario: Searching - a user with an "ADMIN" role can filter and sort the list based on the username
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
            And param asc = false
            And param sortBy = 'NAME'
            And param searchTerm = 'lucide'
        When method GET
        Then status 200
            And match $ == schemas.desk.index
            And match $.total == 1
            And match $.data[*].name == [ 'Translucide' ]
