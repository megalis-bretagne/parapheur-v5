@ip-core @api-v1
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
    Scenario Outline: Permissions - ${scenario.title.role(role)} ${scenario.title.status(status)} create a desk in an existing tenant
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
    Scenario Outline: Permissions - ${scenario.title.role(role)} cannot create a desk in a non-existing tenant
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

    @data-validation @todo @karate-todo @karate-todo-put
    Scenario Outline: Data validation - a user with an "ADMIN" role ${scenario.title.status(status)} create a desk with ${description}
        * api_v1.auth.login('cnoir', 'a123456')
        * def requestData = uniqueRequestData
        * requestData[field] = utils.eval(value)

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
            And request requestData
        When method POST
        Then status <status>
            And if (<status> === 201) utils.assert("$ == schemas.desk.element")
            And if (<status> !== 201) utils.assert("$ == schemas.error")

        Examples:
            | status | field        | value!                                                        | description                                |
            | 201    | name         | eval(utils.string.getRandom(255, 'tmp-'))                     | a name that is up to 255 characters        |
            | 201    | parentDeskId | eval(api_v1.desk.getIdByName(existingTenantId, 'tmp-', true)) | a parent desk that does exist              |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | status | field        | value!                                                        | description                                |
            | 201    | description  | eval(utils.string.getRandom(300))                             | a description that is up to 300 characters |
            | 400    | name         | ''                                                            | an empty name                              |
            | 400    | name         | ' '                                                           | a space as a name                          |
            | 400    | name         | eval(utils.string.getByLength(256))                           | a name that is too long                    |
            | 409    | name         | eval(api_v1.desk.getIdByName(existingTenantId, 'tmp-', true)) | a name that already exists                 |
            | 400    | description  | eval(utils.string.getByLength(301))                           | a description that is too long             |
            | 400    | parentDeskId | eval(api_v1.desk.getNonExistingId())                          | a parent desk that doesn't exist           |
