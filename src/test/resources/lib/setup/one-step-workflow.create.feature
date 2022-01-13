@karate-function @ignore
Feature: Workflow setup lib

    Scenario: Create one-step workflow
        * def tenantId = api_v1.entity.getIdByName(tenant)
        * def deskId = api_v1.desk.getIdByName(tenantId, deskName)
        * def key = api_v1.desk.getKeyStringFromNameString(name)

        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And request
"""
{
    "steps": [
        {
            "validators": [
                "#(deskId)"
            ],
            "validationMode": "SIMPLE",
            "name": "#(type)",
            "type": "#(type)",
            "parallelType": "OR"
        }
    ],
    "name": "#(name)",
    "id": "#(key)",
    "key": "#(key)",
    "deploymentId": "#(key)"
}
"""
            When method POST
            Then status 201
