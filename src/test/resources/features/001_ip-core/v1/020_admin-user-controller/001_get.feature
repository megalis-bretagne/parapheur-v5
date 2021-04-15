@ip-core @api-v1
Feature: GET /api/admin/tenant/{tenantId}/user (List users)

	Background:
		* api_v1.auth.login('user', 'password')
		* def existingTenantId = api_v1.entity.getIdByName('Default tenant')
		* def nonExistingTenantId = api_v1.entity.getNonExistingId()

	@permissions
	Scenario: Permissions - a user with an "ADMIN" role can get the list from an existing tenant
		* api_v1.auth.login('cnoir', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant/', existingTenantId, '/user'
			And header Accept = 'application/json'
		When method GET
		Then status 200
			And match $ == schemas.user.index
			And match $.total == 5
			And match $.data[*].userName == [ 'ablanc', 'cnoir', 'stranslucide', 'ltransparent', 'user' ]

	@permissions @fixme-ip-core
	Scenario: Permissions - a user with an "ADMIN" role cannot get the list from a non-existing tenant
		* api_v1.auth.login('cnoir', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant/', nonExistingTenantId, '/user'
			And header Accept = 'application/json'
		When method GET
		Then status 404

	@permissions @fixme-ip-core
	Scenario: Permissions - a user with a "FUNCTIONAL_ADMIN" role cannot get the list from an existing tenant
		* api_v1.auth.login('ablanc', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant/', existingTenantId, '/user'
			And header Accept = 'application/json'
		When method GET
		Then status 403

	@permissions @fixme-ip-core
	Scenario: Permissions - a user with a "FUNCTIONAL_ADMIN" role cannot get the list from a non-existing tenant
		* api_v1.auth.login('ablanc', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant/', nonExistingTenantId, '/user'
			And header Accept = 'application/json'
		When method GET
		Then status 403

	@permissions @fixme-ip-core
	Scenario: Permissions - a user with a "NONE" role cannot get the list from an existing tenant
		* api_v1.auth.login('ltransparent', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant/', existingTenantId, '/user'
			And header Accept = 'application/json'
		When method GET
		Then status 403

	@permissions @fixme-ip-core
	Scenario: Permissions - a user with a "NONE" role cannot get the list from a non-existing tenant
		* api_v1.auth.login('ltransparent', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant/', nonExistingTenantId, '/user'
			And header Accept = 'application/json'
		When method GET
		Then status 403

	@permissions @fixme-ip-core
	Scenario: Permissions - an unauthenticated user cannot get the list from an existing tenant
		* api_v1.auth.login('', '')

		Given url baseUrl
			And path '/api/admin/tenant/', existingTenantId, '/user'
			And header Accept = 'application/json'
		When method GET
		Then status 401

	@permissions @fixme-ip-core
	Scenario: Permissions - an unauthenticated user cannot get the list from a non-existing tenant
		* api_v1.auth.login('', '')

		Given url baseUrl
			And path '/api/admin/tenant/', nonExistingTenantId, '/user'
			And header Accept = 'application/json'
		When method GET
		Then status 401

	@searching
	Scenario: Searching - a user with an "ADMIN" role can filter and sort the list based on the username
		* api_v1.auth.login('cnoir', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant/', existingTenantId, '/user'
			And header Accept = 'application/json'
			And param asc = false
			And param sortBy = 'USERNAME'
			And param searchTerm = 'la'
		When method GET
		Then status 200
			And match $ == schemas.user.index
			And match $.total == 2
			And match $.data[*].userName == [ 'ltransparent', 'ablanc' ]

