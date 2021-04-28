@ip-core @api-v1
Feature: POST /api/admin/tenant/{tenantId}/desk (Create a new desk)

    Background:
    * api_v1.auth.login('user', 'password')
    * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
    * def nonExistingTenantId = api_v1.entity.getNonExistingId()
    * def unique = 'tmp-' + utils.getUUID()
    * def description = 'Bureau ' + unique

    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} create a desk in an existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
            And request
"""
{
    'name': '#(unique)',
    'description': '#(description)',
    'parentDeskId': null
}
"""
        When method POST
        Then status <status>
            And if (<status> === 201) karate.match("$ == schemas.desk.element")
            And if (<status> === 201) karate.match("$.name == unique")
            And if (<status> === 201) karate.match("$.description == description")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 201    |
        @fixme-ip-core
        Examples:
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot create a desk in a non-existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/desk'
            And header Accept = 'application/json'
            And request
"""
{
    'name': '#(unique)',
    'description': '#(description)',
    'parentDeskId': null
}
"""
        When method POST
        Then status <status>

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @fixme-ip-core
        Examples:
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @data-validation @proposal
    Scenario: Data validation - a user with an "ADMIN" role cannot create a desk with empty data
        * api_v1.auth.login('cnoir', 'a123456')
        * def tenantId = api_v1.entity.getIdByName('Default tenant')

        Given url baseUrl
            And path '/api/admin/tenant/', tenantId, '/desk'
            And header Accept = 'application/json'
            And request
"""
{
    'name': '',
    'description': '',
    'parentDeskId': null
}
"""
        When method POST
        Then status 400
