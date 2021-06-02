@karate-function
Feature: Tenant lib

    Scenario: Create temporary tenant
        * def requestData = { name:  '#(name)' }

        Given url baseUrl
            And path '/api/v1/admin/tenant/'
            And header Accept = 'application/json'
            And request requestData
        When method POST
        Then status 201
