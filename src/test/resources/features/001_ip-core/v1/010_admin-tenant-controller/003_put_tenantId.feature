@ip-core @api-v1
Feature: PUT /api/admin/tenant/{tenantId} (Edit tenant)

    Background:
        * api_v1.auth.login('user', 'password')
        * def unique = 'tmp-' + utils.getUUID()
        * def cleanRequestData = { name: '#(unique)' }

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'edit an existing tenant', status)}
        # Create a temporary tenant
        * api_v1.auth.login('user', 'password')
        * def id = api_v1.entity.createTemporary()

		# Try to edit it
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', id
            And header Accept = 'application/json'
            And request cleanRequestData
        When method PUT
        Then status <status>
            And if (<status> === 200) utils.assert("$ == schemas.tenant.element")
            And if (<status> === 200) utils.assert("$ contains cleanRequestData")
            And if (<status> !== 200) utils.assert("$ == schemas.error")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 200    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: ${scenario.title.permissions(role, 'edit a non-existing tenant', status)}
        * def id = api_v1.entity.getNonExistingId()
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', id
            And header Accept = 'application/json'
            And request cleanRequestData
        When method PUT
        Then status <status>
            And utils.assert("$ == schemas.error")

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
    Scenario Outline: ${scenario.title.validation('ADMIN', 'edit an existing tenant', status, data)}
        # Create a temporary tenant
        * api_v1.auth.login('user', 'password')
        * def id = api_v1.entity.createTemporary()

        # Try to edit it
        * api_v1.auth.login('cnoir', 'a123456')
        * def requestData = cleanRequestData
        * requestData[field] = utils.eval(value)

        Given url baseUrl
            And path '/api/admin/tenant/', id
            And header Accept = 'application/json'
            And request requestData
        When method PUT
        Then status <status>
            And if (<status> === 200) utils.assert("$ == schemas.tenant.element")
            And if (<status> === 200) utils.assert("$ contains requestData")
            And if (<status> !== 200) utils.assert("$ == schemas.error")

        Examples:
            | status | field | value!                                      | data                                |
            | 200    | name  | eval(utils.string.getRandom(1))             | a name that is at least 1 character |
            | 200    | name  | eval(utils.string.getRandom(64, 'tmp-'))    | a name that is up to 64 characters  |
        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | status | field | value!                                      | data                                |
            | 400    | name  | ''                                          | an empty name                       |
            | 400    | name  | ' '                                         | a space as a name                   |
            | 400    | name  | eval(utils.string.getRandom(65, 'tmp-'))  | a name that is too long             |
            | 409    | name  | 'Montpellier Méditerranée Métropole'        | a name that already exists          |

