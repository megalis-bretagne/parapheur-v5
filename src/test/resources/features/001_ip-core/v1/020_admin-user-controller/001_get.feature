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
			And if (<status> === 200) karate.match("$ == schemas.user.index")
			And if (<status> === 200) karate.match("$.total == 5")
			And if (<status> === 200) karate.match("$.data[*].userName == [ 'ablanc', 'cnoir', 'stranslucide', 'ltransparent', 'user' ]")

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

		Examples:
			| role             | username     | password | status |
			| ADMIN            | cnoir        | a123456  | 404    |
		@fixme-ip-core @issue-ip-core-78
		Examples:
			| role             | username     | password | status |
			| FUNCTIONAL_ADMIN | ablanc       | a123456  | 404    |
			| NONE             | ltransparent | a123456  | 404    |
			|                  |              |          | 401    |

	@searching
	Scenario: Searching - a user with an "ADMIN" role can filter and sort the list from an existing tenant based on the username
		* api_v1.auth.login('user', 'password')
		* def existingTenantId = api_v1.entity.getIdByName('Default tenant')

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

