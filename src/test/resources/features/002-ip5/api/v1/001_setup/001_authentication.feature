@api @ip5 @setup @check-setup
Feature: POST /auth/realms/api/v1/protocol/openid-connect/token (Authentication)

	@authentication
	Scenario Outline: Successful authentication for role "${role}" with "${username}" and "${password}"
		* api_v1.auth.login('<username>', '<password>', 200)

		Examples:
			| role             | username     | password |
			| ADMIN            | cnoir        | a123456  |
			| TENANT_ADMIN     | vgris        | a123456  |
			| FUNCTIONAL_ADMIN | ablanc       | a123456  |
			| NONE             | ltransparent | a123456  |

	@authentication
	Scenario Outline: Unsuccessful authentication with "${username === null ? '' : username}" and "${password === null ? '' : password}"
		* api_v1.auth.login('<username>', '<password>', 401)

		Examples:
			| username  | password      |
			|           |               |
			| user      | wrongpassword |
			| wronguser | password      |
