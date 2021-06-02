@ip-core @api-v1
Feature: GET /api/v1/admin/tenant/{tenantId}/user (List users)

	@permissions
	Scenario Outline: ${scenario.title.permissions(role, 'get the user list from an existing tenant', status)}
		* api_v1.auth.login('user', 'password')
		* def existingTenantId = api_v1.entity.getIdByName('Default tenant')

		* api_v1.auth.login('<username>', '<password>')

		Given url baseUrl
			And path '/api/v1/admin/tenant/', existingTenantId, '/user'
			And header Accept = 'application/json'
		When method GET
		Then status <status>
			And if (<status> === 200) utils.assert("$ == schemas.user.index")
			And if (<status> !== 200) utils.assert("$ == schemas.error")

		Examples:
			| role             | username     | password | status |
			| ADMIN            | cnoir        | a123456  | 200    |
		@fixme-ip-core @issue-ip-core-78
		Examples:
			| role             | username     | password | status |
			| FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
			| NONE             | ltransparent | a123456  | 403    |
			|                  |              |          | 401    |

	@permissions
	Scenario Outline: ${scenario.title.permissions(role, 'get the user list from a non-existing tenant', status)}
		* api_v1.auth.login('user', 'password')
		* def nonExistingTenantId = api_v1.entity.getNonExistingId()

		* api_v1.auth.login('<username>', '<password>')

		Given url baseUrl
			And path '/api/v1/admin/tenant/', nonExistingTenantId, '/user'
			And header Accept = 'application/json'
		When method GET
		Then status <status>
			And match $ == schemas.error

		@fixme-ip-core @issue-ip-core-78 @issue-ip-core-todo
		Examples:
			| role             | username     | password | status |
			| ADMIN            | cnoir        | a123456  | 404    |
			| FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
			| NONE             | ltransparent | a123456  | 403    |
			|                  |              |          | 401    |

	@searching
	Scenario Outline: ${scenario.title.searching('ADMIN', 'get the user list', 200, total, searchTerm, sortBy, asc)}
		* api_v1.auth.login('user', 'password')
		* def existingTenantId = api_v1.entity.getIdByName('Default tenant')
		* api_v1.auth.login('cnoir', 'a123456')

		Given url baseUrl
			And path '/api/v1/admin/tenant/', existingTenantId, '/user'
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
			| searchTerm | sortBy     | asc!  | total | field     | value!                                                        |
			|            | USERNAME   | true  | 5     | userName  | [ 'ablanc', 'cnoir', 'ltransparent', 'stranslucide', 'user' ] |
			|            | USERNAME   | false | 5     | userName  | [ 'user', 'stranslucide', 'ltransparent', 'cnoir', 'ablanc' ] |
			| foo        | USERNAME   | false | 0     | userName  | []                                                            |
			| la         | EMAIL      | true  | 2     | email     | [ 'ablanc@dom.local', 'ltransparent@dom.local' ]              |
			| la         | EMAIL      | false | 2     | email     | [ 'ltransparent@dom.local', 'ablanc@dom.local' ]              |
			| la         | FIRST_NAME | true  | 2     | firstName | [ 'Aurélie', 'Laetitia' ]                                     |
			| la         | FIRST_NAME | false | 2     | firstName | [ 'Laetitia', 'Aurélie' ]                                     |
			| la         | LAST_NAME  | true  | 2     | lastName  | [ 'Blanc', 'Transparent' ]                                    |
			| la         | LAST_NAME  | false | 2     | lastName  | [ 'Transparent', 'Blanc' ]                                    |
			| la         | USERNAME   | true  | 2     | userName  | [ 'ablanc', 'ltransparent' ]                                  |
			| la         | USERNAME   | false | 2     | userName  | [ 'ltransparent', 'ablanc' ]                                  |
			| aurélie    | FIRST_NAME | null  | 1     | firstName | [ 'Aurélie' ]                                                 |
			| AURÉLIE    | FIRST_NAME | null  | 1     | firstName | [ 'Aurélie' ]                                                 |
		@fixme-ip-core @issue-ip-core-todo
		Examples:
			| searchTerm | sortBy     | asc!  | total | field     | value!                                                        |
			| aurelie    | FIRST_NAME | null  | 1     | firstName | [ 'Aurélie' ]                                                 |
			| AURELIE    | FIRST_NAME | null  | 1     | firstName | [ 'Aurélie' ]                                                 |
			| aurélié    | FIRST_NAME | null  | 1     | firstName | [ 'Aurélie' ]                                                 |
			| AURÉLIÉ    | FIRST_NAME | null  | 1     | firstName | [ 'Aurélie' ]                                                 |
