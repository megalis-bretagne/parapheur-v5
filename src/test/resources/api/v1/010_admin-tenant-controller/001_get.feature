Feature: GET /api/admin/tenant (List tenants)

	@permissions
	Scenario: Permissions - a user with an "ADMIN" role can get the list
		* api_v1.auth.login('cnoir', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
		When method GET
		Then status 200
			And match $ == schemas.tenant.index
			And match $.total == 3
			And match $.data[*].name == [ 'Default tenant', 'Libriciel SCOP', 'Montpellier Méditerranée Métropole' ]

	@permissions @fixme-ip-core
	Scenario: Permissions - a user with a "FUNCTIONAL_ADMIN" role cannot get the list
		* api_v1.auth.login('ablanc', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
		When method GET
		Then status 403

	@permissions @fixme-ip-core
	Scenario: Permissions - a user with a "NONE" role cannot get the list
		* api_v1.auth.login('ltransparent', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
		When method GET
		Then status 403

	@permissions @fixme-ip-core
	Scenario: Permissions - an unauthenticated user cannot get the list
		* api_v1.auth.login('', '')

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
		When method GET
		Then status 401

	@searching @fixme-ip-core
	Scenario: Searching - a user with an "ADMIN" role can filter and sort the list based on the tenant name
		* api_v1.auth.login('cnoir', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
			And param asc = false
			And param sortBy = 'NAME'
			And param searchTerm = 'el'
		When method GET
		Then status 200
			And match $ == schemas.tenant.index
			And match $.total == 2
			And match $.data[*].name == [ 'Montpellier Méditerranée Métropole', 'Libriciel SCOP' ]
