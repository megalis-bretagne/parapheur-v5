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

	@data-validation @proposal @fixme-ip
	Scenario Outline: Data validation - a user with an "ADMIN" role cannot create a tenant with ${wrong_data}
		* api_v1.auth.login('cnoir', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
			And request { name: '#(name)'}
		When method POST
		Then status 400
			And match $ ==
"""
{
	"path":"#string",
	"error":"##string",
	"message":"#string",
	"timestamp":"#string",
	"status":#number
}
"""
		* print response

		Examples:
			| status | name!                            | wrong_data                 |
			| 400    | ''                               | an empty name              |
			| 400    | ' '                              | an space as a name         |
			| 400    | 'tmp-' + '0123456789'.repeat(30) | a name that is too long    |
			| 409    | 'Default tenant'                 | a name that already exists |
