@ip-core @api-v1
Feature: PUT /api/admin/tenant/{tenantId} (Edit tenant)

    Background:
        * api_v1.auth.login('user', 'password')
        * def unique = 'tmp-' + utils.getUUID()
        * def cleanRequestData = { name: '#(unique)' }

    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} edit an existing tenant
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
            And if (<status> === 201) utils.assert("$ == schemas.tenant.element")
            And if (<status> === 201) utils.assert("$ contains { id: '#(id)', name: '#(name)' }")

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
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot edit a non-existing tenant
        * def id = api_v1.entity.getNonExistingId()
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', id
            And header Accept = 'application/json'
            And request cleanRequestData
        When method PUT
        Then status <status>

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
            | NONE             | ltransparent | a123456  | 404    |
        @fixme-ip-core @issue-ip-core-78
        Examples:
            | role             | username     | password | status |
            |                  |              |          | 401    |

    @data-validation
    Scenario Outline: Data validation - a user with an "ADMIN" role cannot edit a tenant with ${wrong_data}
        # Create a temporary tenant
        * api_v1.auth.login('user', 'password')
        * def id = api_v1.entity.createTemporary()

        # Try to edit it
        * api_v1.auth.login('cnoir', 'a123456')
        * def requestData = cleanRequestData
        * requestData[field] = utils.eval(value)

        Given url baseUrl
            And path '/api/admin/tenant'
            And header Accept = 'application/json'
            And request requestData
        When method POST
            Then status 400
            And match $ == schemas.error

        @fixme-ip-core @issue-ip-core-todo
        Examples:
            | status | field | value!                                      | wrong_data                 |
            | 400    | name  | ''                                          | an empty name              |
            | 400    | name  | ' '                                         | a space as a name          |
            | 400    | name  | eval(utils.string.getByLength(512, 'tmp-')) | a name that is too long    |
            | 409    | name  | 'Montpellier Méditerranée Métropole'        | a name that already exists |
