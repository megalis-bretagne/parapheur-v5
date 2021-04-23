@ip-core @api-v1
Feature: DELETE /api/admin/tenant/{tenantId} (Delete tenant)

	@permissions @fixme-ip-core
	Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} delete an existing tenant
		* api_v1.auth.login('user', 'password')
		* def id = api_v1.entity.createTemporary()
		* api_v1.auth.login('<username>', '<password>')

		Given url baseUrl
			And path '/api/admin/tenant/', id
			And header Accept = 'application/json'
		When method DELETE
		Then status <status>

		Examples:
			| role             | username     | password | status |
			| ADMIN            | cnoir        | a123456  | 204    |
			| FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
			| NONE             | ltransparent | a123456  | 403    |
			|                  |              |          | 401    |

	@permissions @fixme-ip-core
	Scenario Outline: Permissions - ${scenario.outline.role(role)} ${scenario.outline.status(status)} cannot delete a non-existing tenant
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
			| FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
			| NONE             | ltransparent | a123456  | 403    |
			|                  |              |          | 401    |
