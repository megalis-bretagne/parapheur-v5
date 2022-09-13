@ip-core @api-v1 @admin-tenant-controller
Feature: GET /api/v1/admin/tenant (List tenants)

	Background:
		* api_v1.auth.login('user', 'password')
		* def list = api_v1.entity.getListByPartialName('tmp-')
		* call read('classpath:lib/api/setup/tenant.delete.feature') list

	@permissions
	Scenario Outline: ${scenario.title.permissions(role, 'get the tenant list', status)}
		* api_v1.auth.login('<username>', '<password>')

		Given url baseUrl
			And path '/api/v1/admin/tenant'
			And header Accept = 'application/json'
		When method GET
		Then status <status>
			And if (<status> === 200) utils.assert("$ == schemas.tenant.index")
			And if (<status> !== 200) utils.assert("$ == schemas.error")

		Examples:
			| role             | username     | password | status |
			| ADMIN            | cnoir        | a123456  | 200    |
			| TENANT_ADMIN     | vgris        | a123456  | 403    |
			| FUNCTIONAL_ADMIN | ablanc       | a123456  | 403    |
			| NONE             | ltransparent | a123456  | 403    |
			|                  |              |          | 401    |

	@searching
	Scenario Outline: ${scenario.title.searching('ADMIN', 'get the tenant list', 200, total, searchTerm, sort, direction)}
		* api_v1.auth.login('cnoir', 'a123456')

		Given url baseUrl
			And path '/api/v1/admin/tenant/'
			And header Accept = 'application/json'
			And param sort = '<sort>,<direction>'
			And param searchTerm = '<searchTerm>'
		When method GET
		Then status 200
			And match $ == schemas.tenant.index
			And match $.total == <total>
			And match $.data[*]['<field>'] == <value>

		Examples:
			| searchTerm   | sort | direction | total | field | value!                                                                       |
			|              | NAME | ASC       | 3     | name  | [ 'Default tenant', 'Libriciel SCOP', 'Montpellier Méditerranée Métropole' ] |
			|              | NAME | DESC      | 3     | name  | [ 'Montpellier Méditerranée Métropole', 'Libriciel SCOP', 'Default tenant' ] |
			| foo          |      |           | 0     | name  | []                                                                           |
			| el           | NAME | ASC       | 2     | name  | [ 'Libriciel SCOP', 'Montpellier Méditerranée Métropole' ]                   |
			| el           | NAME | DESC      | 2     | name  | [ 'Montpellier Méditerranée Métropole', 'Libriciel SCOP' ]                   |
			| méditerranée |      |           | 1     | name  | [ 'Montpellier Méditerranée Métropole' ]                                     |
			| MÉDITERRANÉE |      |           | 1     | name  | [ 'Montpellier Méditerranée Métropole' ]                                     |
