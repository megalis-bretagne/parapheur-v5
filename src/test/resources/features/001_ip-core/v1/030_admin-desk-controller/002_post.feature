@ip-core @api-v1 @karate-todo @karate-todo-passing-test-with-correct-parentDeskId
Feature: POST /api/admin/tenant/{tenantId}/desk (Create a new desk)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def unique = 'tmp-' + utils.getUUID()
        * def description = 'Bureau ' + unique
        * def uniqueRequestData =
"""
{
    'name': '#(unique)',
    'description': '#(description)',
    'parentDeskId': null
}
"""

    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} create a desk in an existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
            And request uniqueRequestData

        When method POST
        Then status <status>
            And if (<status> === 201) utils.assert("$ == schemas.desk.element")
            And if (<status> === 201) utils.assert("$.name == unique")
            And if (<status> === 201) utils.assert("$.description == description")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 201    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot create a desk in a non-existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/desk'
            And header Accept = 'application/json'
            And request uniqueRequestData
        When method POST
        Then status <status>

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            |                  |              |          | 401    |

    @data-validation
    Scenario Outline: Data validation - a user with an "ADMIN" role cannot create a desk with ${wrong_data}
        * api_v1.auth.login('cnoir', 'a123456')
        * def tenantId = api_v1.entity.getIdByName('Default tenant')
        * def requestData = uniqueRequestData
        * requestData[field] = utils.eval(value)

        Given url baseUrl
            And path '/api/admin/tenant/', tenantId, '/desk'
            And header Accept = 'application/json'
            And request requestData
        When method POST
        Then status <status>
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | status | field        | value!                                      | wrong_data                       |
            | 400    | name         | ''                                          | an empty name                    |
            | 400    | name         | ' '                                         | a space as a name                |
            | 400    | name         | eval(utils.string.getByLength(257, 'tmp-')) | a name that is too long          |
            | 409    | name         | 'Translucide'                               | a name that already exists       |
            | 400    | description  | eval(utils.string.getByLength(301, 'tmp-')) | a description that is too long   |
            | 400    | parentDeskId | eval(api_v1.desk.getNonExistingId())        | a parent desk that doesn't exist |
