@ip-core @api-v1
Feature: PUT /api/v1/admin/tenant/{tenantId}/desk/{deskId} (Edit desk)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def existingDeskId = api_v1.desk.createTemporary(existingTenantId)
        * def nonExistingDeskId = api_v1.desk.getNonExistingId()
        * def existingDeskData = api_v1.desk.getById(existingTenantId, existingDeskId)

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'edit an existing desk from an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk/', existingDeskId
            And header Accept = 'application/json'
            And request existingDeskData
        When method PUT
        Then status <status>
            And if (<status> === 200) utils.assert("response == ''")
            And if (<status> !== 200) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 200    |
        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'edit an existing desk from a non-existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/desk/', existingDeskId
            And header Accept = 'application/json'
            And request existingDeskData
        When method PUT
        Then status <status>
            And match $ == schemas.error

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'edit a non-existing desk from an existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk/', nonExistingDeskId
            And header Accept = 'application/json'
            And request existingDeskData
        When method PUT
        Then status <status>
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'edit a non-existing desk from a non-existing tenant', status)}
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', nonExistingTenantId, '/desk/', nonExistingDeskId
            And header Accept = 'application/json'
            And request existingDeskData
        When method PUT
        Then status <status>
            And match $ == schemas.error

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @data-validation
    Scenario Outline: ${scenario.title.validation('ADMIN', 'edit a desk in an existing tenant', status, data)}
        * api_v1.auth.login('cnoir', 'a123456')
        * def requestData = existingDeskData
        * requestData[field] = utils.eval(value)

        Given url baseUrl
            And path '/api/v1/admin/tenant/', existingTenantId, '/desk/', existingDeskId
            And header Accept = 'application/json'
            And request requestData

        When method PUT
        Then status <status>
            And if (<status> === 200) utils.assert("response == ''")
            And if (<status> !== 200) utils.assert("$ == schemas.error")

        Examples:
            | status | field        | value!                                                        | data                                       |
            | 200    | name         | eval(utils.string.getRandom(1))                               | a name that is 1 character long            |
            | 200    | name         | eval(utils.string.getRandom(255, 'tmp-'))                     | a name that is up to 255 characters        |
            | 200    | parentDeskId | eval(api_v1.desk.getIdByName(existingTenantId, 'tmp-', true)) | a parent desk that does exist              |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | status | field        | value!                                                        | data                                       |
            | 200    | description  | eval(utils.string.getRandom(300))                             | a description that is up to 300 characters |
            | 400    | name         | ''                                                            | an empty name                              |
            | 400    | name         | ' '                                                           | a space as a name                          |
            | 400    | name         | eval(utils.string.getRandom(256))                             | a name that is too long                    |
            | 409    | name         | eval(api_v1.desk.getIdByName(existingTenantId, 'tmp-', true)) | a name that already exists                 |
            | 400    | description  | eval(utils.string.getRandom(301))                             | a description that is too long             |
            | 400    | parentDeskId | eval(api_v1.desk.getNonExistingId())                          | a parent desk that doesn't exist           |
