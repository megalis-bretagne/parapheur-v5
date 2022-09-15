@api @ip5 @ip-core @api-v1 @admin-tenant-controller
Feature: POST /api/v1/admin/tenant (Create tenant)

	Background:
		* ip5.api.v1.auth.login('user', 'password')
		* def list = ip5.api.v1.entity.getListByPartialName('tmp-')
		* call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

		* def unique = 'tmp-' + ip.utils.getUUID()
		* def cleanRequestData = { name: '#(unique)' }

	@permissions
	Scenario Outline: ${ip5.scenario.title.permissions(role, 'create a tenant', status)}
		* ip5.api.v1.auth.login('<username>', '<password>')

		Given url baseUrl
			And path '/api/v1/admin/tenant'
			And header Accept = 'application/json'
			And request cleanRequestData

		When method POST
		Then status <status>
			And if (<status> === 201) ip.utils.assert("$ == schemas.tenant.element")
			And if (<status> !== 201) ip.utils.assert("$ == schemas.error")

		Examples:
			| role             | username     | password | status |
			| ADMIN            | cnoir        | a123456  | 201    |
			| TENANT_ADMIN     | vgris        | a123456  | 403    |
			| FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
			| NONE             | ltransparent | a123456  | 403    |
			|                  |              |          | 401    |

	@data-validation
	Scenario Outline: ${ip5.scenario.title.validation('ADMIN', 'create a tenant', status, data)}
		* ip5.api.v1.auth.login('cnoir', 'a123456')
		* def requestData = cleanRequestData
		* requestData[field] = ip.utils.eval(value)

		Given url baseUrl
			And path '/api/v1/admin/tenant'
			And header Accept = 'application/json'
			And request requestData
		When method POST
		Then status <status>
			And if (<status> === 201) ip.utils.assert("$ == schemas.tenant.element")
			And if (<status> === 201) ip.utils.assert("$ contains requestData")
			And if (<status> !== 201) ip.utils.assert("$ == schemas.error")

		Examples:
			| status | field | value!                                   | data                                    |
			| 201    | name  | eval(ip.utils.string.getRandom(1))          | a name that is 1 character long         |
			| 201    | name  | eval(ip.utils.string.getRandom(64, 'tmp-')) | a name that is up to 64 characters long |
		@fixme-ip5 @issue-todo
		Examples:
			| status | field | value!                                   | data                                    |
			| 400    | name  | ''                                       | an empty name                           |
			| 400    | name  | ' '                                      | a space as a name                       |
			| 400    | name  | eval(ip.utils.string.getRandom(65, 'tmp-')) | a name that is above 64 characters long |
			| 409    | name  | 'Montpellier Méditerranée Métropole'     | a name that already exists              |
