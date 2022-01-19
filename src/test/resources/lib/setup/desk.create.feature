@karate-function @ignore
Feature: Desk setup lib

    Scenario: Create desk
        * def tenantId = api_v1.entity.getIdByName(tenant)
        * def payload = api_v1.desk.getCreationPayload(tenantId, name, owners, parent, associated, permissions)

        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/desk'
            And header Accept = 'application/json'
            And request payload
          When method POST
          Then status 201
