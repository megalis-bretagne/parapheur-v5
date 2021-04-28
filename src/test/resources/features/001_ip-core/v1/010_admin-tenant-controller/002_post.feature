@ip-core @api-v1
Feature: POST /api/admin/tenant (Create tenant)

	@permissions
	Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} create a tenant
		* api_v1.auth.login('<username>', '<password>')
		* def name = 'tmp-' + utils.getUUID()

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
			And request { name: '#(name)'}
		When method POST
		Then status <status>
			And if (<status> === 201) karate.match("$ == schemas.tenant.element")
			And if (<status> === 201) karate.match("$.name == '#(name)'")

		Examples:
			| role             | username     | password | status |
			| ADMIN            | cnoir        | a123456  | 201    |
		@fixme-ip-core
		Examples:
			| role             | username     | password | status |
			| FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
			| NONE             | ltransparent | a123456  | 403    |
			|                  |              |          | 401    |

	@data-validation @proposal @todo-ip-core
	Scenario: Data validation - a user with an "ADMIN" role cannot create a tenant with an empty name
		* api_v1.auth.login('cnoir', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
			And request { name: ''}
		When method POST
		Then status 201
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
		Then status 201
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
