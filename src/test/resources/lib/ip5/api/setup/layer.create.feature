@karate-function @ignore
Feature: Layer setup lib

    Scenario: Create layer
        * def tenantId = ip5.api.v1.entity.getIdByName(tenant)

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + tenantId + '/layer'
            And header Accept = 'application/json'
            And request { name: '#(name)'}
        When method POST
        Then status 201
