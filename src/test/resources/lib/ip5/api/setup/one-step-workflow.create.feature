@karate-function @ignore
Feature: Workflow setup lib

  Scenario: Create one-step workflow
    * def tenantId = ip5.api.v1.entity.getIdByName(tenant)
    * def deskId = deskName.indexOf('#') == 0 ? deskName : ip5.api.v1.desk.getIdByName(tenantId, deskName)
    * def key = ip5.api.v1.desk.getKeyStringFromNameString(name)

    * def getWorkflowMandatoryMetadataIds =
"""
function (tenantId, metadataKeys) {
    var result = [];
    for (var i=0;i<metadataKeys.length;i++) {
        result.push(ip5.api.v1.metadata.getIdByKey(tenantId, metadataKeys[i]));
    }
    return result;
}
"""

    * def mandatoryValidationMetadata = getWorkflowMandatoryMetadataIds(tenantId, karate.get('mandatoryValidationMetadata', []))
    * def mandatoryRejectionMetadata = getWorkflowMandatoryMetadataIds(tenantId, karate.get('mandatoryRejectionMetadata', []))

    Given url baseUrl
    And path '/api/provisioning/v1/admin/tenant/', tenantId, '/workflow-definition'
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
            "mandatoryRejectionMetadataIds": #(mandatoryRejectionMetadata)
        },
        {
          "type": "ARCHIVE",
          "validatingDeskIds": [
            "i_Parapheur_reserved_emitter"
          ],
          "notifiedDeskIds": []
        }
    ],
    "name": "#(name)",
    "id": "#(key)",
    "key": "#(key)",
    "finalDeskId": "i_Parapheur_reserved_emitter",
    "finalNotifiedDeskIds": []
}
"""
    When method POST
    Then status 201
