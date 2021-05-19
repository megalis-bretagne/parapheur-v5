@ip-core @api-v1
Feature: GET /api/admin/tenant/{tenantId}/user (List users)

	@permissions
	Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} get the list from an existing tenant
		* api_v1.auth.login('user', 'password')
		* def existingTenantId = api_v1.entity.getIdByName('Default tenant')

		* api_v1.auth.login('<username>', '<password>')

		Given url baseUrl
			And path '/api/admin/tenant/', existingTenantId, '/user'
			And header Accept = 'application/json'
		When method GET
		Then status <status>
			And if (<status> === 200) utils.assert("$ == schemas.user.index")
			And if (<status> === 200) utils.assert("$.total == 5")
			And if (<status> === 200) utils.assert("$.data[*].userName == [ 'ablanc', 'cnoir', 'stranslucide', 'ltransparent', 'user' ]")

		Examples:
			| role             | username     | password | status |
			| ADMIN            | cnoir        | a123456  | 200    |
		@fixme-ip-core @issue-ip-core-78
		Examples:
			| role             | username     | password | status |
			| FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
			| NONE             | ltransparent | a123456  | 404    |
			|                  |              |          | 401    |

	@permissions
	Scenario Outline: Permissions - ${scenario.outline.role(role)} cannot get the list from a non-existing tenant
		* api_v1.auth.login('user', 'password')
		* def nonExistingTenantId = api_v1.entity.getNonExistingId()

		* api_v1.auth.login('<username>', '<password>')

		Given url baseUrl
			And path '/api/admin/tenant/', nonExistingTenantId, '/user'
			And header Accept = 'application/json'
		When method GET
		Then status <status>

		@fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
		Examples:
			| role             | username     | password | status |
			| ADMIN            | cnoir        | a123456  | 404    |
			| FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
			| NONE             | ltransparent | a123456  | 404    |
			|                  |              |          | 401    |

	@searching
	Scenario Outline: Searching - a user with an "ADMIN" role can filter the user list and get ${total} result(s) with "${searchTerm}", sorted by ${sortBy}, ${asc == "true" ? 'ascending' : 'descending'}
		* api_v1.auth.login('user', 'password')
		* def existingTenantId = api_v1.entity.getIdByName('Default tenant')
		* api_v1.auth.login('cnoir', 'a123456')

		Given url baseUrl
			And path '/api/admin/tenant/', existingTenantId, '/user'
			And header Accept = 'application/json'
			And param asc = <asc>
			And param sortBy = '<sortBy>'
			And param searchTerm = '<searchTerm>'
		When method GET
		Then status 200
			And match $ == schemas.user.index
			And match $.total == <total>
			And match $.data[*]['<field>'] == <value>

        Examples:
			| searchTerm | sortBy     | asc   | total | field     | value!                                           |
			| foo        | USERNAME   | false | 0     | userName  | []                                               |
			| la         | EMAIL      | true  | 2     | email     | [ 'ablanc@dom.local', 'ltransparent@dom.local' ] |
			| la         | EMAIL      | false | 2     | email     | [ 'ltransparent@dom.local', 'ablanc@dom.local' ] |
			| la         | FIRST_NAME | true  | 2     | firstName | [ 'Aurélie', 'Laetitia' ]                        |
			| la         | FIRST_NAME | false | 2     | firstName | [ 'Laetitia', 'Aurélie' ]                        |
			| la         | LAST_NAME  | true  | 2     | lastName  | [ 'Blanc', 'Transparent' ]                       |
			| la         | LAST_NAME  | false | 2     | lastName  | [ 'Transparent', 'Blanc' ]                       |
			| la         | USERNAME   | true  | 2     | userName  | [ 'ablanc', 'ltransparent' ]                     |
			| la         | USERNAME   | false | 2     | userName  | [ 'ltransparent', 'ablanc' ]                     |
