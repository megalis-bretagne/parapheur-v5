@karate-function @ignore
Feature: Type setup lib

    Scenario: Create type
        * def defaults =
"""
{
    "name": "",
    "signatureFormat": "",
    "protocol": "",
    "signatureVisible": false,
    "signatureLocation": "",
    "signatureZipCode": "",
    "signaturePosition": {}
}
"""
        * def row = karate.merge(defaults, __row)
        * def payload = karate.merge({"description": row['name']}, row)

        * def tenantId = ip5.api.v1.entity.getIdByName(tenant)

        Given url baseUrl
            And path '/api/provisioning/v1/admin/tenant/', tenantId, '/typology/type'
            And header Accept = 'application/json'
            And request payload
        When method POST
        Then status 201
#
