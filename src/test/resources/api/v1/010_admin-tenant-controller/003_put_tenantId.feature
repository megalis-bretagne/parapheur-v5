Feature: PUT /api/admin/tenant/{tenantId} (Edit tenant)

    @permissions
    Scenario: Permissions - a user with an "ADMIN" role can edit an existing tenant
        # Create a temporary tenant
        * api_v1.auth.login('user', 'password')
        * def id = api_v1.entity.createTemporary()
        * def name = 'tmp-' + utils.getUUID()

		# Try to edit it
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', id
            And header Accept = 'application/json'
            And request { name: '#(name)'}
        When method PUT
        Then status 200
            And match $ == schemas.tenant.element
            And match $ contains { id: '#(id)', name: '#(name)' }

    @permissions
    Scenario: Permissions - a user with an "ADMIN" role cannot edit a non-existing tenant
        * def id = api_v1.entity.getNonExistingId()
        * def name = 'tmp-' + utils.getUUID()

        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', id
            And header Accept = 'application/json'
            And request { name: '#(name)'}
        When method PUT
        Then status 404

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with a "FUNCTIONAL_ADMIN" role cannot edit an existing tenant
        # Create a temporary tenant
        * api_v1.auth.login('user', 'password')
        * def id = api_v1.entity.createTemporary()
        * def name = 'tmp-' + utils.getUUID()

		# Try to edit it
        * api_v1.auth.login('ablanc', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', id
            And header Accept = 'application/json'
            And request { name: '#(name)'}
        When method PUT
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with a "FUNCTIONAL_ADMIN" role cannot edit a non-existing tenant
        * def id = api_v1.entity.getNonExistingId()
        * def name = 'tmp-' + utils.getUUID()

        * api_v1.auth.login('ablanc', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', id
            And header Accept = 'application/json'
            And request { name: '#(name)'}
        When method PUT
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with a "NONE" role cannot edit an existing tenant
        # Create a temporary tenant
        * api_v1.auth.login('user', 'password')
        * def id = api_v1.entity.createTemporary()
        * def name = 'tmp-' + utils.getUUID()

		# Try to edit it
        * api_v1.auth.login('ltransparent', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', id
            And header Accept = 'application/json'
            And request { name: '#(name)'}
        When method PUT
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with a "NONE" role cannot edit a non-existing tenant
        * def id = api_v1.entity.getNonExistingId()
        * def name = 'tmp-' + utils.getUUID()
        * api_v1.auth.login('ltransparent', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', id
            And header Accept = 'application/json'
            And request { name: '#(name)'}
        When method PUT
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - an unauthenticated user cannot edit an existing tenant
        # Create a temporary tenant
        * api_v1.auth.login('user', 'password')
        * def id = api_v1.entity.createTemporary()
        * def name = 'tmp-' + utils.getUUID()

		# Try to edit it
        * api_v1.auth.login('', '')

        Given url baseUrl
            And path '/api/admin/tenant/', id
            And header Accept = 'application/json'
            And request { name: '#(name)'}
        When method PUT
        Then status 401

    @permissions @fixme-ip-core
    Scenario: Permissions - an unauthenticated user cannot edit a non-existing tenant
        * def id = api_v1.entity.getNonExistingId()
        * def name = 'tmp-' + utils.getUUID()

        * api_v1.auth.login('', '')
        Given url baseUrl
            And path '/api/admin/tenant/', id
            And header Accept = 'application/json'
            And request { name: '#(name)'}
        When method PUT
        Then status 401

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
