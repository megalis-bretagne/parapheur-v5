@karate-function @ignore
Feature: Metadata setup lib

    Scenario: Create metadata
        * def tenantId = ip5.api.v1.entity.getIdByName(tenant)

        Given url baseUrl
            And path '/api/provisioning/v1/admin/tenant/', tenantId, '/metadata'
            And header Accept = 'application/json'
            And request
"""
{
    "key": "#(key)",
    "name": "#(name)",
    "type": "#(type)",
    "restrictedValues": #(restrictedValues),
    "ipngMetadataKeys": []
}
"""
        When method POST
        Then status 201
        And ip.utils.assert("$ == schemas.metadata.element")
