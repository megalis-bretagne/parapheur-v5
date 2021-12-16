@ip-core @api-v1
Feature: POST /api/v1/admin/tenant/{tenantId}/desk (Create a new desk)

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
    "shortName": "#(unique)",
    'description': '#(description)',
    'parentDeskId': null
}
"""

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a desk in an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
            And request uniqueRequestData

        When method POST
        Then status <status>
            And if (<status> === 201) utils.assert("$ == schemas.desk.element")
            And if (<status> !== 201) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 201    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a desk in a non-existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/desk'
            And header Accept = 'application/json'
            And request uniqueRequestData
        When method POST
        Then status <status>
            #And match $ == schemas.error

        Examples:
            | role             | username     | password | status |
            | TENANT_ADMIN     | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @data-validation
    Scenario Outline: ${scenario.title.validation('TENANT_ADMIN', 'create a desk in an existing tenant', status, data)}
        * api_v1.auth.login('cnoir', 'a123456')
        * copy requestData = uniqueRequestData
        * requestData[field] = utils.eval(value)
        * copy expected = requestData
        * remove expected.parentDeskId
        * if (requestData['parentDeskId'] == null) expected['directParent'] = null
        * if (requestData['parentDeskId'] != null) expected['directParent'] = { id: requestData['parentDeskId'] }

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk'
            And header Accept = 'application/json'
            And request requestData
        When method POST
        Then status <status>
            And if (<status> === 201) utils.assert("$ == schemas.desk.element")
            And if (<status> === 201) utils.assert("$ contains expected")
            And if (<status> !== 201) utils.assert("$ == schemas.error")

        Examples:
            | status | field        | value!                                                        | data                                       |
            | 201    | name         | eval(utils.string.getRandom(1))                               | a name that is 1 character long            |
            | 201    | name         | eval(utils.string.getRandom(255, 'tmp-'))                     | a name that is up to 255 characters        |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | status | field        | value!                                                        | data                                       |
            | 201    | parentDeskId | eval(api_v1.desk.getIdByName(existingTenantId, 'tmp-', true)) | a parent desk that does exist              |
            | 201    | description  | eval(utils.string.getRandom(300))                             | a description that is up to 300 characters |
            | 400    | name         | ''                                                            | an empty name                              |
            | 400    | name         | ' '                                                           | a space as a name                          |
            | 400    | name         | eval(utils.string.getRandom(256))                             | a name that is too long                    |
            | 409    | name         | eval(api_v1.desk.getIdByName(existingTenantId, 'tmp-', true)) | a name that already exists                 |
            | 400    | description  | eval(utils.string.getRandom(301))                             | a description that is too long             |
            | 400    | parentDeskId | eval(api_v1.desk.getNonExistingId())                          | a parent desk that doesn't exist           |
