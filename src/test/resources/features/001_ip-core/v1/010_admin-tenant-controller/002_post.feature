@ip-core @api-v1
Feature: POST /api/admin/tenant (Create tenant)

	Background:
		* api_v1.auth.login('user', 'password')
		* def unique = 'tmp-' + utils.getUUID()
		* def cleanRequestData = { name: '#(unique)' }

	@permissions
	Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} create a tenant
		* api_v1.auth.login('<username>', '<password>')

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
			And request cleanRequestData

		When method POST
		Then status <status>
			And if (<status> === 201) karate.match("$ == schemas.tenant.element")
			And if (<status> === 201) karate.match("$.name == '#(cleanRequestData.name)'")

		Examples:
			| role             | username     | password | status |
			| ADMIN            | cnoir        | a123456  | 201    |
		@fixme-ip-core @issue-ip-core-78
		Examples:
			| role             | username     | password | status |
			| FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
			| NONE             | ltransparent | a123456  | 403    |
			|                  |              |          | 401    |

	@data-validation
	Scenario Outline: Data validation - a user with an "ADMIN" role cannot create a tenant with ${wrong_data}
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
			| 409    | name  | 'Default tenant'                            | a name that already exists |
