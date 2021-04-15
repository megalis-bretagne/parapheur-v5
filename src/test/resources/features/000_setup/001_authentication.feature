@setup @check-setup
Feature: POST /auth/realms/api/protocol/openid-connect/token (Authentication)

	@authentication
	Scenario Outline: Successful authentication
		* api_v1.auth.login('<username>', '<password>')

		Examples:
			| username     | password |
			| cnoir        | a123456  |
			| ablanc       | a123456  |
			| ltransparent | a123456  |

	@authentication
	Scenario Outline: Unsuccessful authentication
		* api_v1.auth.login('<username>', '<password>', false)

		Examples:
			| username  | password      |
			|           |               |
			| user      | wrongpassword |
			| wronguser | password      |
