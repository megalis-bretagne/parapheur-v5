@karate-function
Feature: Desk lib

  Scenario: Create temporary desk
    * def requestData =
"""
    {
        name : '#(name)',
        description : '#(description)',
        parentDeskId : '#(parentDeskId)'
    }
"""

    Given url baseUrl
        And path '/api/v1/admin/tenant/', tenantId, '/desk'
        And header Accept = 'application/json'
        And request requestData
    When method POST
    Then status 201
