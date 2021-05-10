@ip-core @api-v1
Feature: GET /api/admin/tenant (List tenants)

	@permissions
	Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} get the tenant list
		* api_v1.auth.login('<username>', '<password>')

		Given url baseUrl
			And path '/api/admin/tenant'
			And header Accept = 'application/json'
		When method GET
		Then status <status>
			And if (<status> === 200) karate.match("$ == schemas.tenant.index")
			And if (<status> === 200) karate.match("$.total == 3")
			And if (<status> === 200) karate.match("$.data[*].name == [ 'Default tenant', 'Libriciel SCOP', 'Montpellier Méditerranée Métropole' ]")

		Examples:
			| role             | username     | password | status |
			| ADMIN            | cnoir        | a123456  | 200    |
		@fixme-ip-core @issue-ip-core-78
		Examples:
			| role             | username     | password | status |
			| FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
			| NONE             | ltransparent | a123456  | 403    |
			|                  |              |          | 401    |

	@searching @fixme-ip-core @issue-ip-core-todo
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
