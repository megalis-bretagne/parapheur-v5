@ip-core @api-v1
Feature: PUT /api/admin/tenant/{tenantId} (Edit tenant)

    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} edit an existing tenant
        # Create a temporary tenant
        * api_v1.auth.login('user', 'password')
        * def id = api_v1.entity.createTemporary()
        * def name = 'tmp-' + utils.getUUID()

		# Try to edit it
        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', id
            And header Accept = 'application/json'
            And request { name: '#(name)'}
        When method PUT
        Then status <status>
            And if (<status> === 201) karate.match("$ == schemas.tenant.element")
            And if (<status> === 201) karate.match("$ contains { id: '#(id)', name: '#(name)' }")

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 200    |
        @fixme-ip-core
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @permissions
    Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot edit a non-existing tenant
        * def id = api_v1.entity.getNonExistingId()
        * def name = 'tmp-' + utils.getUUID()

        * api_v1.auth.login('<username>', '<password>')

        Given url baseUrl
            And path '/api/admin/tenant/', id
            And header Accept = 'application/json'
            And request { name: '#(name)'}
        When method PUT
        Then status <status>

        Examples:
            | role             | username     | password | status |
            | ADMIN            | cnoir        | a123456  | 404    |
        @fixme-ip-core
        Examples:
            | role             | username     | password | status |
            | FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
            | NONE             | ltransparent | a123456  | 403    |
            |                  |              |          | 401    |

    @data-validation @proposal @todo-ip-core
    Scenario: Data validation - a user with an "ADMIN" role cannot edit a tenant with an empty name
        # Create a temporary tenant
        * api_v1.auth.login('user', 'password')
        * def id = api_v1.entity.createTemporary()

        # Try to edit it
        * api_v1.auth.login('cnoir', 'a123456')
        Given url baseUrl
            And path '/api/admin/tenant/', id
            And header Accept = 'application/json'
            And request { name: ''}
        When method PUT
        Then status 400

    @data-validation @proposal @todo-ip-core
    Scenario: Data validation - a user with an "ADMIN" role cannot edit a tenant with a name that already exists
        # Create a temporary tenant
        * api_v1.auth.login('user', 'password')
        * def id = api_v1.entity.createTemporary()
        * def name = api_v1.entity.getNameById(id)

		# Create a second tenant that will be edited
        * def id = api_v1.entity.createTemporary()
        * api_v1.auth.login('cnoir', 'a123456')

        # Try to edit the second tenant with the name of the first created one
        Given url baseUrl
            And path '/api/admin/tenant/', id
            And header Accept = 'application/json'
            And request { name: '#(name)'}
        When method PUT
        Then status 400

    @data-validation @fixme-ip-core
    Scenario: Data validation - a user with an "ADMIN" role cannot edit a tenant with a name that is too long
        # Create a temporary tenant
        * api_v1.auth.login('user', 'password')
        * def id = api_v1.entity.createTemporary()

        # Try to edit it
        * api_v1.auth.login('cnoir', 'a123456')
        * def name = 'tmp-' + '0123456789'.repeat(30)

        Given url baseUrl
            And path '/api/admin/tenant/', id
            And header Accept = 'application/json'
            And request { name: '#(name)'}
        When method PUT
        Then status 400
