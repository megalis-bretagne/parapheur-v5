@karate-function @ignore
Feature: Tenant setup lib

    Scenario: Create tenant
        Given url baseUrl
            And path '/api/v1/admin/tenant'
            And header Accept = 'application/json'
            And request { name: '#(name)'}
        When method POST
        Then status 201
            And match $ contains { "id": "#uuid", "name": "#string" }
            And match $.name == '#(name)'
