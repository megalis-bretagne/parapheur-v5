@api @ip5 @setup @check-setup
Feature: POST /auth/realms/api/v1/protocol/openid-connect/token (Authentication)

	@authentication
	Scenario Outline: Successful authentication for role "${role}" with "${username}" and "${password}"
		* ip5.api.v1.auth.login('<username>', '<password>', 200)

		Examples:
			| role             | username     | password |
			| ADMIN            | cnoir        | Ilenfautpeupouretreheureux  |
			| TENANT_ADMIN     | vgris        | Ilenfautpeupouretreheureux  |
			| FUNCTIONAL_ADMIN | ablanc       | Ilenfautpeupouretreheureux  |
			| NONE             | ltransparent | Ilenfautpeupouretreheureux  |

	@authentication
	Scenario Outline: Unsuccessful authentication with "${username === null ? '' : username}" and "${password === null ? '' : password}"
		* ip5.api.v1.auth.login('<username>', '<password>', 401)

		Examples:
			| username  | password      |
			|           |               |
			| user      | wrongpassword |
			| wronguser | password      |
