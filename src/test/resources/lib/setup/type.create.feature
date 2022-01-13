@karate-function @ignore
Feature: Type setup lib

    Scenario: Create type
        * def tenantId = api_v1.entity.getIdByName(tenant)

        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/typology/type'
            And header Accept = 'application/json'
            And request
"""
{
    "name": "#(name)",
    "description": "#(description)",
    "signatureFormat": "#(signatureFormat)",
    "protocol": "#(protocol)",
    "signatureVisible": true,
    "signatureLocation": "#(signatureLocation)",
    "signatureZipCode": "#(signatureZipCode)",
    "signaturePosition": #(signaturePosition)
}
"""
        When method POST
        Then status 201
