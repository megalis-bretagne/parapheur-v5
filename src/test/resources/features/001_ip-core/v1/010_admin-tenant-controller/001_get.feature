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
			And if (<status> === 200) utils.assert("$ == schemas.tenant.index")
			And if (<status> === 200) utils.assert("$.total == 3")
			And if (<status> === 200) utils.assert("$.data[*].name == [ 'Default tenant', 'Libriciel SCOP', 'Montpellier Méditerranée Métropole' ]")

		Examples:
			| role             | username     | password | status |
			| ADMIN            | cnoir        | a123456  | 200    |
		@fixme-ip-core @issue-ip-core-78
		Examples:
			| role             | username     | password | status |
			| FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
			| NONE             | ltransparent | a123456  | 403    |
			|                  |              |          | 401    |

	@searching
	Scenario Outline: Searching - a user with an "ADMIN" role can filter the tenant list and get ${total} result(s) with "${searchTerm}", sorted by ${sortBy}, ${asc == "true" ? 'ascending' : 'descending'}
		* api_v1.auth.login('cnoir', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant/'
			And header Accept = 'application/json'
			And param asc = <asc>
			And param sortBy = '<sortBy>'
			And param searchTerm = '<searchTerm>'
		When method GET
		Then status 200
			And match $ == schemas.tenant.index
			And match $.total == <total>
			And match $.data[*]['<field>'] == <value>

		@fixme-ip-core @issue-ip-core-142
		Examples:
			| searchTerm | sortBy | asc   | total | field | value!                                                     |
			| foo        | NAME   | false | 0     | name  | []                                                         |
			| el         | NAME   | true  | 2     | name  | [ 'Libriciel SCOP', 'Montpellier Méditerranée Métropole' ] |
			| el         | NAME   | false | 2     | name  | [ 'Montpellier Méditerranée Métropole', 'Libriciel SCOP' ] |
