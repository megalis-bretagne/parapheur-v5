@karate-function @ignore
Feature: Workflow setup lib

    Scenario: Create one-step workflow
        * def tenantId = api_v1.entity.getIdByName(tenant)
        * def deskId = deskName.indexOf('#') == 0 ? deskName : api_v1.desk.getIdByName(tenantId, deskName)
        * def key = api_v1.desk.getKeyStringFromNameString(name)
        * def getWorkflowMandatoryMetadatas =
"""
function (tenantId, metadataKeys) {
    var result = [];
    for (var i=0;i<metadataKeys.length;i++) {
        result.push({
            id: api_v1.metadata.getIdByKey(tenantId, metadataKeys[i]),
            key: null,
            name: null,
            index: null,
            type: null,
            restrictedValues: []
        });
    }
    return result;
}
"""
        * def mandatoryMetadata = getWorkflowMandatoryMetadatas(tenantId, mandatoryMetadata)

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
            "parallelType": "OR",
            "mandatoryMetadata": #(mandatoryMetadata)
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
