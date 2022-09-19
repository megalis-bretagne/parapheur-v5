@karate-function @ignore
Feature: Desk setup lib

    Scenario: Create desk
        * def tenantId = ip5.api.v1.entity.getIdByName(tenant)
        * def shortName = ip.utils.isEmpty(__row['shortName']) === true ? name : __row['shortName']
        * def payload = ip5.api.v1.desk.getCreationPayload(tenantId, name, shortName, owners, parent, associated, permissions)

        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/desk'
            And header Accept = 'application/json'
            And request payload
          When method POST
          Then status 201
