@ip-core @api-v1
Feature: DELETE /api/admin/tenant/{tenantId} (Delete tenant)

	@permissions
	Scenario Outline: ${scenario.title.permissions(role, 'delete an existing tenant', status)}
		* api_v1.auth.login('user', 'password')
		* def id = api_v1.entity.createTemporary()

		* api_v1.auth.login('<username>', '<password>')

		Given url baseUrl
			And path '/api/admin/tenant/', id
			And header Accept = 'application/json'
		When method DELETE
		Then status <status>
			And if (<status> === 204) utils.assert("response == ''")
			And if (<status> !== 204) utils.assert("$ == schemas.error")

		Examples:
			| role             | username     | password | status |
			| ADMIN            | cnoir        | a123456  | 204    |
		@fixme-ip-core @issue-ip-core-78
		Examples:
			| role             | username     | password | status |
			| FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
			| NONE             | ltransparent | a123456  | 403    |
			|                  |              |          | 401    |

	@permissions
	Scenario Outline: ${scenario.title.permissions(role, 'delete a non-existing tenant', status)}
		* def id = api_v1.entity.getNonExistingId()
		* api_v1.auth.login('<username>', '<password>')

		Given url baseUrl
			And path '/api/admin/tenant/', id
			And header Accept = 'application/json'
		When method DELETE
		Then status <status>

		Examples:
			| role             | username     | password | status |
			| ADMIN            | cnoir        | a123456  | 404    |
		@fixme-ip-core @issue-ip-core-78
		Examples:
			| role             | username     | password | status |
			| FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
			| NONE             | ltransparent | a123456  | 403    |
			|                  |              |          | 401    |
