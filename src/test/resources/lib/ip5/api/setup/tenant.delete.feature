@karate-function @ignore
Feature: Tenant setup lib

Scenario: Delete tenant
    Given url baseUrl
        And path '/api/v1/admin/tenant/', id
        And header Accept = 'application/json'
    When method DELETE
    Then status 204
        And ip.utils.assert("response == ''")
