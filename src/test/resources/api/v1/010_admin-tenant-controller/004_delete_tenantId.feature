Feature: DELETE /api/admin/tenant/{tenantId} (Delete tenant)

	@permissions @fixme-ip-core
	Scenario: Permissions - a user with an "ADMIN" role can delete an existing tenant
        # Create a temporary tenant
		* api_v1.auth.login('user', 'password')
		* def id = api_v1.entity.createTemporary()
		* def name = 'tmp-' + utils.getUUID()

		# Try to delete it
		* api_v1.auth.login('cnoir', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant/', id
			And header Accept = 'application/json'
		When method DELETE
		Then status 204

	@permissions
	Scenario: Permissions - a user with an "ADMIN" role cannot delete a non-existing tenant
		# Create a temporary tenant
		* def id = api_v1.entity.getNonExistingId()
		* def name = 'tmp-' + utils.getUUID()

		# Try to delete it
		* api_v1.auth.login('cnoir', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant/', id
			And header Accept = 'application/json'
		When method DELETE
		Then status 404

	@permissions @fixme-ip-core
	Scenario: Permissions - a user with a "FUNCTIONAL_ADMIN" role cannot delete an existing tenant
        # Create a temporary tenant
		* api_v1.auth.login('user', 'password')
		* def id = api_v1.entity.createTemporary()
		* def name = 'tmp-' + utils.getUUID()

		# Try to delete it
		* api_v1.auth.login('ablanc', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant/', id
			And header Accept = 'application/json'
		When method DELETE
		Then status 403

	@permissions @fixme-ip-core
	Scenario: Permissions - a user with a "FUNCTIONAL_ADMIN" role cannot delete a non-existing tenant
		# Create a temporary tenant
		* def id = api_v1.entity.getNonExistingId()
		* def name = 'tmp-' + utils.getUUID()

		# Try to delete it
		* api_v1.auth.login('ablanc', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant/', id
			And header Accept = 'application/json'
		When method DELETE
		Then status 403


	@permissions @fixme-ip-core
	Scenario: Permissions - a user with an "NONE" role cannot delete an existing tenant
        # Create a temporary tenant
		* api_v1.auth.login('user', 'password')
		* def id = api_v1.entity.createTemporary()
		* def name = 'tmp-' + utils.getUUID()

		# Try to delete it
		* api_v1.auth.login('ltransparent', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant/', id
			And header Accept = 'application/json'
		When method DELETE
		Then status 403

	@permissions @fixme-ip-core
	Scenario: Permissions - a user with an "NONE" role cannot delete a non-existing tenant
		# Create a temporary tenant
		* def id = api_v1.entity.getNonExistingId()
		* def name = 'tmp-' + utils.getUUID()

		# Try to delete it
		* api_v1.auth.login('ltransparent', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant/', id
			And header Accept = 'application/json'
		When method DELETE
		Then status 403


	@permissions @fixme-ip-core
	Scenario: Permissions - an unauthenticated user cannot delete an existing tenant
        # Create a temporary tenant
		* api_v1.auth.login('user', 'password')
		* def id = api_v1.entity.createTemporary()
		* def name = 'tmp-' + utils.getUUID()

		# Try to delete it
		* api_v1.auth.login('', '')

		Given url baseUrl
			And path '/api/admin/tenant/', id
			And header Accept = 'application/json'
		When method DELETE
		Then status 401

	@permissions @fixme-ip-core
	Scenario: Permissions - an unauthenticated user cannot delete a non-existing tenant
		# Create a temporary tenant
		* def id = api_v1.entity.getNonExistingId()
		* def name = 'tmp-' + utils.getUUID()

		# Try to delete it
		* api_v1.auth.login('', '')

		Given url baseUrl
			And path '/api/admin/tenant/', id
			And header Accept = 'application/json'
		When method DELETE
		Then status 401
