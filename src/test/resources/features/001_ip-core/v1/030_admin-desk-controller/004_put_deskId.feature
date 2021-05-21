@ip-core @api-v1
Feature: PUT /api/admin/tenant/{tenantId}/desk/{deskId} (Edit desk)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def existingDeskId = api_v1.desk.createTemporary(existingTenantId)
        * def nonExistingDeskId = api_v1.desk.getNonExistingId()
        * def existingDeskData = api_v1.desk.getById(existingTenantId, existingDeskId)

    @permissions @fixme-ip-core
    Scenario Outline: Permissions - ${scenario.title.role(role)} ${scenario.title.status(status)} edit an existing desk from an existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk/', existingDeskId
            And header Accept = 'application/json'
            And request existingDeskData
        When method PUT
        Then status <status>
            And if (<status> === 200) utils.assert("$ == schemas.desk.element")
            And if (<status> === 200) utils.assert("$ contains { id: '#(existingDeskData.id)', name: '#(existingDeskData.name)' }")

        @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 200    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: Permissions - ${scenario.title.role(role)} cannot edit an existing desk from a non-existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/desk/', existingDeskId
            And header Accept = 'application/json'
            And request existingDeskData
        When method PUT
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

    @permissions @fixme-ip-core
    Scenario Outline: Permissions - ${scenario.title.role(role)} cannot edit a non-existing desk from an existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk/', nonExistingDeskId
            And header Accept = 'application/json'
            And request existingDeskData
        When method PUT
        Then status <status>

        @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: Permissions - ${scenario.title.role(role)} cannot edit a non-existing desk from a non-existing tenant
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/desk/', nonExistingDeskId
            And header Accept = 'application/json'
            And request existingDeskData
        When method PUT
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

    @data-validation @fixme-ip-core @issue-ip-core-todo
    Scenario Outline: Data validation - a user with an "ADMIN" role cannot edit a desk with ${wrong_data}
        * api_v1.auth.login('cnoir', 'a123456')
        * def requestData = existingDeskData
        * requestData[field] = utils.eval(value)

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/desk/', existingDeskId
            And header Accept = 'application/json'
            And request requestData

        When method PUT
        Then status <status>
            And match $ == schemas.error

        Examples:
            | status | field        | value!                                      | wrong_data                       |
            | 400    | name         | ''                                          | an empty name                    |
            | 400    | name         | ' '                                         | a space as a name                |
            | 400    | name         | eval(utils.string.getByLength(257, 'tmp-')) | a name that is too long          |
            | 409    | name         | 'Translucide'                               | a name that already exists       |
            | 400    | description  | eval(utils.string.getByLength(301, 'tmp-')) | a description that is too long   |
            | 400    | parentDeskId | eval(api_v1.desk.getNonExistingId())        | a parent desk that doesn't exist |
