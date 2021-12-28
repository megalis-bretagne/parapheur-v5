@ip-core @api-v1 @todo
Feature: POST /api/v1/admin/tenant/{tenantId}/typology/type/{typeId}/subtype (Create subtype)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')

    @permissions
    Scenario: Permissions - a user with an "TENANT_ADMIN" role can create a subtype and associate it to an existing type
        * api_v1.auth.login('cnoir', 'a123456')
        * def tenantId = api_v1.entity.getIdByName('Default tenant')
        * def workflowKey = api_v1.workflow.getKeyByName(tenantId, 'tmp-', true)
        * def typeId = api_v1.type.getIdByName(tenantId, 'tmp-', true)
        * def name = 'tmp-' + utils.getUUID()

        Given url baseUrl
        And path '/api/v1/admin/tenant/', tenantId, 'typology/type/', typeId, '/subtype'
            And header Accept = 'application/json'
            And request
"""
{
	"annotationsAllowed": true,
	"creationPermittedDeskIds": null,
	"description": "Description",
	"externalSignatureConfig": {},
	"externalSignatureConfigId": null,
	"filterableByDeskIds": null,
	"ipngTypeKeys": [],
	"name" : "#(name)",
	"sealCertificateId": "#(sealCertificateId)",
	"subtypeLayerRequestList": [],
	"subtypeMetadataList": [],
	"subtypeMetadataRequestList": [],
	"validationWorkflowId": "#(workflowKey)"
}
"""
#    "creationWorkflowId": null,
#    "isDigitalSignatureMandatory": true
        When method POST
        Then status 201
            And utils.assert("$ == {'value': '#uuid'}")
