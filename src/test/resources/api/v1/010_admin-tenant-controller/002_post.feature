Feature: POST /api/admin/tenant (Create tenant)

	@permissions
	Scenario: Permissions - a user with an "ADMIN" role can create a tenant
		* api_v1.auth.login('cnoir', 'a123456')
		* def name = 'tmp-' + utils.getUUID()

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
			And request { name: '#(name)'}
		When method POST
		Then status 201
			And match $ == schemas.tenant.element
			And match $.name == '#(name)'

	@permissions @fixme-ip-core
	Scenario: Permissions - a user with a "FUNCTIONAL_ADMIN" role cannot create a tenant
		* api_v1.auth.login('ablanc', 'a123456')
		* def name = 'tmp-' + utils.getUUID()

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
			And request { name: '#(name)'}
		When method POST
		Then status 403

	@permissions @fixme-ip-core
	Scenario: Permissions - a user with a "NONE" role cannot create a tenant
		* api_v1.auth.login('ltransparent', 'a123456')
		* def name = 'tmp-' + utils.getUUID()

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
			And request { name: '#(name)'}
		When method POST
		Then status 403

	@permissions @fixme-ip-core
	Scenario: Permissions - an unauthenticated user cannot create a tenant
		* api_v1.auth.login('', '')
		* def name = 'tmp-' + utils.getUUID()

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
			And request { name: '#(name)'}
		When method POST
		Then status 401

	@data-validation @proposal @todo-ip-core
	Scenario: Data validation - a user with an "ADMIN" role cannot create a tenant with an empty name
		* api_v1.auth.login('cnoir', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
			And request { name: ''}
		When method POST
		Then status 200
		# proposal
		# Then status 400

	@data-validation @proposal @todo-ip-core
	Scenario: Data validation - a user with an "ADMIN" role cannot create a tenant with a name that already exists
		* api_v1.auth.login('user', 'password')
		* def id = api_v1.entity.createTemporary()
		* def name = api_v1.entity.getNameById(id)

		# Try to create another tenant with the previously created name
		* api_v1.auth.login('cnoir', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
			And request { name: '#(name)'}
		When method POST
		Then status 200
		# proposal
		# Then status 400

	@data-validation @fixme-ip-core
	Scenario: Data validation - a user with an "ADMIN" role cannot create a tenant with a name that is too long
		* api_v1.auth.login('cnoir', 'a123456')
		* def name = 'tmp-' + '0123456789'.repeat(30)

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
			And request { name: '#(name)'}
		When method POST
		Then status 400
