@karate-function @ignore
Feature: Subtype setup lib

    Scenario: Create subtype
        * def tenantId = api_v1.entity.getIdByName(tenant)
        * def workflowKey = workflow == '' ? null : api_v1.workflow.getKeyByName(tenantId, workflow)
        * def typeId = api_v1.type.getIdByName(tenantId, type)
        * def sealCertificateId = sealCertificate == '' ? null : api_v1.sealCertificate.getIdByName(tenantId, sealCertificate)
        * def script = workflowSelectionScript == '' ? '' : karate.readAsString(workflowSelectionScript)
        * def replaceMetadataKeyById =
"""
function (tenantId, subtypeMetadataRequestList) {
    for (var i = 0;i < subtypeMetadataRequestList.length;i++) {
        if (typeof subtypeMetadataRequestList[i]['metadataKey'] !== 'undefined') {
            subtypeMetadataRequestList[i]['metadataId'] = api_v1.metadata.getIdByKey(
                tenantId,
                subtypeMetadataRequestList[i]['metadataKey']
            );
            delete subtypeMetadataRequestList[i]['metadataKey'];
        }
    }

    return subtypeMetadataRequestList;
}
"""

        * def metadataRequestList = replaceMetadataKeyById(tenantId, subtypeMetadataRequestList)

        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/typology/type/', typeId, '/subtype'
            And header Accept = 'application/json'
            And request
"""
{
    "annotationsAllowed": true,
    "creationPermittedDeskIds": null,
    "description": "#(description)",
    "externalSignatureConfig": {},
    "externalSignatureConfigId": null,
    "filterableByDeskIds": null,
    "ipngTypeKeys": [],
    "name": "#(name)",
    "sealCertificateId": "#(sealCertificateId)",
    "subtypeLayerRequestList": [],
    "subtypeMetadataList": [],
    "subtypeMetadataRequestList": #(metadataRequestList),
    "validationWorkflowId": "#(workflowKey)",
    "workflowSelectionScript": "#(script)"
}
"""
        When method POST
        Then status 201
