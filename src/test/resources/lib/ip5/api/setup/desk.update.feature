@karate-function @ignore
Feature: Desk setup lib

    Scenario: Update desk
        * def tenantId = api_v1.entity.getIdByName(tenant)
        * def shortName = ip.utils.isEmpty(__row['shortName']) === true ? name : __row['shortName']
        * def payload = api_v1.desk.getCreationPayload(tenantId, name, shortName, owners, parent, associated, permissions)
        * def deskId = api_v1.desk.getIdByName(tenantId, name)

        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/desk/', deskId
            And header Accept = 'application/json'
            And request payload
        When method PUT
        Then status 200
