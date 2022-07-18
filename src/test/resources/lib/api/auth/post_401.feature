@karate-function
Feature: Authentication lib
	Background:
		* api_v1.auth.logout()
		* configure cookies = null

	Scenario: Assert error
		Given url baseUrl
			And path '/auth/realms/api/protocol/openid-connect/token'
			And form field client_id = 'admin-cli'
			And form field username = __arg.username
			And form field password = __arg.password
			And form field grant_type = 'password'
			And header Content-Type = 'application/x-www-form-urlencoded; charset=utf-8'
		When method POST
		Then status 401
			And match $ == schemas.auth.post_401
