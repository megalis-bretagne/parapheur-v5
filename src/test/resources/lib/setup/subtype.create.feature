@karate-function @ignore
Feature: Subtype setup lib

    Scenario: Create subtype
        * def tenantId = api_v1.entity.getIdByName(tenant)
        * def workflowKey = api_v1.workflow.getKeyByName(tenantId, workflow)
        * def typeId = api_v1.type.getIdByName(tenantId, type)
        * def sealCertificateId = sealCertificate == '' ? null : api_v1.sealCertificate.getIdByName(tenantId, sealCertificate)

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
    "subtypeMetadataRequestList": [],
    "validationWorkflowId": "#(workflowKey)"
}
"""
        When method POST
        Then status 201
