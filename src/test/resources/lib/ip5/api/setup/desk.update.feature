@karate-function @ignore
Feature: Desk setup lib

    Scenario: Update desk
        * def tenantId = ip5.api.v1.entity.getIdByName(tenant)
        * def shortName = ip.utils.isEmpty(__row['shortName']) === true ? name : __row['shortName']
        * def payload = ip5.api.v1.desk.getCreationPayload(tenantId, name, shortName, owners, parent, associated, permissions)
        * def deskId = ip5.api.v1.desk.getIdByName(tenantId, name)

        Given url baseUrl
            And path '/api/provisioning/v1/admin/tenant/', tenantId, '/desk/', deskId
            And header Accept = 'application/json'
            And request payload
        When method PUT
        Then status 200
