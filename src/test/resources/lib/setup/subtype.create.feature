@karate-function @ignore
Feature: Subtype setup lib

    Scenario: Create subtype
        * pause(5)
        * def tenantId = api_v1.entity.getIdByName(tenant)
        * def typeId = api_v1.type.getIdByName(tenantId, type)
        * def defaults =
"""
{
    "annotationsAllowed": false,
    "creationPermittedDeskIds": null,
    "digitalSignatureMandatory": false,
    "externalSignatureConfig": {},
    "externalSignatureConfigId": null,
    "filterableByDeskIds": null,
    "ipngTypeKeys": [],
    "multiDocuments": false,
    "name": "",
    "sealCertificateId": "",
    "secureMailServerId": "",
    "subtypeLayerList": [],
    "subtypeLayerRequestList": [],
    "subtypeMetadataList": [],
    "subtypeMetadataRequestList": [],
    "validationWorkflowId": "",
    "workflowSelectionScript": ""
}
"""

        * def payload = karate.merge(defaults, __row)
        * payload['description'] = utils.isEmpty(payload['description']) ? payload['name'] : payload['description']
        * payload['externalSignatureConfigId'] = utils.isEmpty(payload['externalSignatureConfigId']) ? null : api_v1.externalSignature.getIdByName(tenantId, payload['externalSignatureConfigId'])
        * payload['sealCertificateId'] = utils.isEmpty(payload['sealCertificateId']) ? null : api_v1.sealCertificate.getIdByName(tenantId, payload['sealCertificateId'])
        * payload['secureMailServerId'] = utils.isEmpty(payload['secureMailServerId']) ? null : api_v1.secureMailServer.getIdByName(tenantId, payload['secureMailServerId'])
        * payload['validationWorkflowId'] = utils.isEmpty(payload['validationWorkflowId']) ? null : api_v1.workflow.getKeyByName(tenantId, payload['validationWorkflowId'])
        * payload['workflowSelectionScript'] = utils.isEmpty(payload['workflowSelectionScript']) ? '' : karate.readAsString(payload['workflowSelectionScript'])
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

        * payload['subtypeMetadataRequestList'] = replaceMetadataKeyById(tenantId, payload['subtypeMetadataRequestList'])

        * def cleanupPayload =
"""
function(payload, defaults) {
    /*for (var key in payload) {
        if (payload.hasOwnProperty(key) && !defaults.hasOwnProperty(key)) {
             delete payload[key];
        }
    }*/
    var keys = ['externalSignatureConfig', 'secureMailServerId', 'sealCertificateId', 'workflowSelectionScript'];
    for (var key of keys) {
        if (utils.isEmpty(payload[key])) {
            delete payload[key];
        }
    }

    delete payload['tenant'];
    delete payload['type'];

    return payload;
}
"""

        * def payload = cleanupPayload(payload, defaults);

        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/typology/type/', typeId, '/subtype'
            And header Accept = 'application/json'
            And request payload
        When method POST
        Then status 201
