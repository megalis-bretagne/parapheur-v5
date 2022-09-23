@karate-function @ignore
Feature: Workflow setup lib

  Scenario: Create one-step workflow
    * def tenantId = ip5.api.v1.entity.getIdByName(tenant)
    * def deskId = deskName.indexOf('#') == 0 ? deskName : ip5.api.v1.desk.getIdByName(tenantId, deskName)
    * def key = ip5.api.v1.desk.getKeyStringFromNameString(name)
    * def getWorkflowMandatoryMetadatas =
"""
function (tenantId, metadataKeys) {
    var result = [];
    for (var i=0;i<metadataKeys.length;i++) {
        result.push({
            id: ip5.api.v1.metadata.getIdByKey(tenantId, metadataKeys[i]),
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
    * def mandatoryValidationMetadata = getWorkflowMandatoryMetadatas(tenantId, karate.get('mandatoryValidationMetadata', []))
    * def mandatoryRejectionMetadata = getWorkflowMandatoryMetadatas(tenantId, karate.get('mandatoryRejectionMetadata', []))

    Given url baseUrl
    And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
    And header Accept = 'application/json'
    And request
"""
{
    "steps": [
        {
            "validatingDeskIds": [
                "#(deskId)"
            ],
            "type": "#(type)",
            "parallelType": "OR",
            "notifiedDeskIds": [],
            "mandatoryValidationMetadataIds": #(mandatoryValidationMetadata),
            "mandatoryValidationMetadataIds": #(mandatoryRejectionMetadata)
        }
    ],
    "name": "#(name)",
    "id": "#(key)",
    "key": "#(key)",
    "deploymentId": "#(key)",
    "finalDeskId": "##EMITTER##",
    "finalNotifiedDeskIds": []
}
"""
    When method POST
    Then status 201
