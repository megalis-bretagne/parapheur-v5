@api @ip5 @ip-core @api-v1 @admin-typology-controller
Feature: POST /api/v1/admin/tenant/{tenantId}/typology/type (Create type)

    Background:
        * api_v1.auth.login('user', 'password')
        * def list = api_v1.entity.getListByPartialName('tmp-')
        * call read('classpath:lib/api/setup/tenant.delete.feature') list

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a "PADES" type with no protocol and associate it to an existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def name = 'tmp-' + utils.getUUID()

        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/typology/type'
            And header Accept = 'application/json'
            And request
"""
{
    'name': '#(name)',
    'description': 'Description',
    'signatureFormat': 'PADES',
    'signatureVisible': true
}
"""
        When method POST
        Then status <status>
            And if (<status> === 201) utils.assert("$ == schemas.type.element")
            And if (<status> !== 201) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 201    |
            | TENANT_ADMIN     | vgris        | a123456  | 201    |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'create a "PADES" type with no protocol and associate it to a non-existing tenant', status)}
        * api_v1.auth.login('user', 'password')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def name = 'tmp-' + utils.getUUID()

        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/typology/type'
            And header Accept = 'application/json'
            And request
"""
{
    'name': '#(name)',
    'description': 'Description',
    'signatureFormat': 'PADES',
    'signatureVisible': true
}
"""
        When method POST
        Then status <status>
            And utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | TENANT_ADMIN     | vgris        | a123456  | 404    |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @data-validation
    Scenario Outline: ${scenario.title.validation('ADMIN', 'create a type with no protocol and associate it to a non-existing tenant', status, data)}
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def name = 'tmp-' + utils.getUUID()
        * def requestData =
"""
{
    'name': '#(name)',
    'description': 'Description',
    'signatureFormat': 'PADES',
    'signatureVisible': true
}
"""
        * requestData[field] = utils.eval(value)

        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/typology/type'
            And header Accept = 'application/json'
            And request requestData

        When method POST
        Then status <status>
            And if (<status> === 201) utils.assert("$ == schemas.type.element")
            And if (<status> !== 201) utils.assert("$ == schemas.error")

        Examples:
            | status | field           | value!                           | data                                    |
            | 201    | description     | eval(utils.string.getRandom(3))  | a description that is 3 characters long |
            | 201    | name            | eval(utils.string.getRandom(3))  | a name that is 3 characters long        |
            | 201    | signatureFormat | 'PADES'                          | an existing signature format            |
            | 400    | signatureFormat | 'foo'                            | a non existing signature format         |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | status | field           | value!                           | data                                    |
            | 400    | description     | eval(utils.string.getRandom(2))  | a description that is 2 characters long |
            | 400    | name            | eval(utils.string.getRandom(2))  | a name that is 2 characters long        |
            | 400    | name            | eval(utils.string.getRandom(29)) | a name that is 29 characters long       |
