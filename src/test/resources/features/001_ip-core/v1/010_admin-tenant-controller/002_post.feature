@ip-core @api-v1
Feature: POST /api/admin/tenant (Create tenant)

	Background:
		* api_v1.auth.login('user', 'password')
		* def unique = 'tmp-' + utils.getUUID()
		* def cleanRequestData = { name: '#(unique)' }

	@permissions
	Scenario Outline: ${scenario.title.permissions(role, 'create a tenant', status)}
		* api_v1.auth.login('<username>', '<password>')

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
			And request cleanRequestData

		When method POST
		Then status <status>
			And if (<status> === 201) utils.assert("$ == schemas.tenant.element")
			And if (<status> !== 201) utils.assert("$ == schemas.error")

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
	Scenario Outline: ${scenario.title.validation('ADMIN', 'create a tenant', status, data)}
		* api_v1.auth.login('cnoir', 'a123456')
		* def requestData = cleanRequestData
		* requestData[field] = utils.eval(value)

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
			And request requestData
		When method POST
		Then status <status>
			And if (<status> === 201) utils.assert("$ == schemas.tenant.element")
			And if (<status> === 201) utils.assert("$ contains requestData")
			And if (<status> !== 201) utils.assert("$ == schemas.error")

		Examples:
			| status | field | value!                                      | data                                |
			| 201    | name  | eval(utils.string.getRandom(1, 'tmp-'))     | a name that is at least 1 character |
			| 201    | name  | eval(utils.string.getRandom(64, 'tmp-'))    | a name that is up to 64 characters  |
		@fixme-ip-core @issue-ip-core-todo
		Examples:
			| status | field | value!                                      | data                                |
			| 400    | name  | ''                                          | an empty name                       |
			| 400    | name  | ' '                                         | a space as a name                   |
			| 400    | name  | eval(utils.string.getByLength(65, 'tmp-'))  | a name that is too long             |
			| 409    | name  | 'Montpellier Méditerranée Métropole'        | a name that already exists          |
