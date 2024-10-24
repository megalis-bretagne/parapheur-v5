@api @ip5 @ip-core @api-v1 @admin-user-controller
Feature: GET /api/provisioning/v1/admin/tenant/{tenantId}/user (List users)

	Background:
		* ip5.api.v1.auth.login('user', adminUserPwd)
		* def list = ip5.api.v1.entity.getListByPartialName('tmp-')
		* call read('classpath:lib/ip5/api/setup/tenant.delete.feature') list

	@permissions
	Scenario Outline: ${ip5.scenario.title.permissions(role, 'get the user list from an existing tenant', status)}
		* ip5.api.v1.auth.login('user', adminUserPwd)
		* def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')

		* ip5.api.v1.auth.login('<username>', '<password>')

		Given url baseUrl
			And path '/api/v1/admin/tenant/', existingTenantId, '/user'
			And header Accept = 'application/json'
		When method GET
		Then status <status>
			And if (<status> === 200) ip.utils.assert("$ == schemas.user.index")
			And if (<status> !== 200) ip.utils.assert("$ == schemas.error")

		Examples:
			| role             | username     | password | status |
			| ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 200    |
			| TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 200    |
			| FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 403    |
			| NONE             | ltransparent | Ilenfautpeupouretreheureux  | 403    |
			|                  |              |          | 401    |

	@permissions
	Scenario Outline: ${ip5.scenario.title.permissions(role, 'get the user list from a non-existing tenant', status)}
		* ip5.api.v1.auth.login('user', adminUserPwd)
		* def nonExistingTenantId = ip5.api.v1.entity.getNonExistingId()

		* ip5.api.v1.auth.login('<username>', '<password>')

		Given url baseUrl
			And path '/api/v1/admin/tenant/', nonExistingTenantId, '/user'
			And header Accept = 'application/json'
		When method GET
		Then status <status>
			And ip.utils.assert("$ == schemas.error")

		Examples:
			| role             | username     | password | status |
			| ADMIN            | cnoir        | Ilenfautpeupouretreheureux  | 404    |
			| TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  | 404    |
			| FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  | 404    |
			| NONE             | ltransparent | Ilenfautpeupouretreheureux  | 404    |
			|                  |              |          | 404    |

	@searching
	Scenario Outline: ${ip5.scenario.title.searching('ADMIN', 'get the user list', 200, total, searchTerm, sort, direction)}
		* ip5.api.v1.auth.login('user', adminUserPwd)
		* def existingTenantId = ip5.api.v1.entity.getIdByName('Entité initiale')
		* ip5.api.v1.auth.login('cnoir', 'Ilenfautpeupouretreheureux')

		Given url baseUrl
			And path '/api/v1/admin/tenant/', existingTenantId, '/user'
			And header Accept = 'application/json'
			And param sort = '<sort>,<direction>'
			And param searchTerm = '<searchTerm>'
		When method GET
		Then status 200
			And match $ == schemas.user.index
			And match $.total == <total>
			And match $.data[*]['<field>'] == <value>

		Examples:
			| searchTerm | sort       | direction | total | field     | value!                                                                 |
			|            | USERNAME   | ASC       | 6     | userName  | [ 'ablanc', 'cnoir', 'ltransparent', 'stranslucide', 'user', 'vgris' ] |
			|            | USERNAME   | DESC      | 6     | userName  | [ 'vgris', 'user', 'stranslucide', 'ltransparent', 'cnoir', 'ablanc' ] |
			| foo        | USERNAME   | DESC      | 0     | userName  | []                                                                     |
			| la         | EMAIL      | ASC       | 2     | email     | [ 'ablanc@dom.local', 'ltransparent@dom.local' ]                       |
			| la         | EMAIL      | DESC      | 2     | email     | [ 'ltransparent@dom.local', 'ablanc@dom.local' ]                       |
			| la         | FIRST_NAME | ASC       | 2     | firstName | [ 'Aurélie', 'Laetitia' ]                                              |
			| la         | FIRST_NAME | DESC      | 2     | firstName | [ 'Laetitia', 'Aurélie' ]                                              |
			| la         | LAST_NAME  | ASC       | 2     | lastName  | [ 'Blanc', 'Transparent' ]                                             |
			| la         | LAST_NAME  | DESC      | 2     | lastName  | [ 'Transparent', 'Blanc' ]                                             |
			| la         | USERNAME   | ASC       | 2     | userName  | [ 'ablanc', 'ltransparent' ]                                           |
			| la         | USERNAME   | DESC      | 2     | userName  | [ 'ltransparent', 'ablanc' ]                                           |
			| aurélie    | FIRST_NAME | ASC       | 1     | firstName | [ 'Aurélie' ]                                                          |
			| AURÉLIE    | FIRST_NAME | ASC       | 1     | firstName | [ 'Aurélie' ]                                                          |
#		@fixme-ip5 @issue-todo
#		Examples:
#			| searchTerm | sort     | direction  | total | field     | value!                                                                 |
#			| aurelie    | FIRST_NAME | ASC  | 1     | firstName | [ 'Aurélie' ]                                                          |
#			| AURELIE    | FIRST_NAME | ASC  | 1     | firstName | [ 'Aurélie' ]                                                          |
#			| aurélié    | FIRST_NAME | ASC  | 1     | firstName | [ 'Aurélie' ]                                                          |
#			| AURÉLIÉ    | FIRST_NAME | ASC  | 1     | firstName | [ 'Aurélie' ]                                                          |
