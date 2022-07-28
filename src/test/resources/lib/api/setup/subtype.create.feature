@karate-function @ignore
Feature: Subtype setup lib

    Scenario: Create subtype
        * pause(5)
        * def tenantId = api_v1.entity.getIdByName(tenant)
        * def prepareSubtypeLayerList =
"""
function (tenantId, subtypeLayerList) {
    var result = [];
    for (var i = 0;i < subtypeLayerList.length;i++) {
        for (const [layer, association] of Object.entries(subtypeLayerList[i])) {
            var layerId = api_v1.layer.getIdByName(tenantId, layer);
            result.push({
                "layerId": layerId,
                "association": association,
                "compositeId": { "layerId": layerId }
            });
        }
    }
    return result;
}
"""
      * def replaceMetadataKeyById =
"""
function (tenantId, subtypeMetadataList) {
    for (var i = 0;i < subtypeMetadataList.length;i++) {
        if (typeof subtypeMetadataList[i]['metadataKey'] !== 'undefined') {
            subtypeMetadataList[i]['metadataId'] = api_v1.metadata.getIdByKey(
                tenantId,
                subtypeMetadataList[i]['metadataKey']
            );
            delete subtypeMetadataList[i]['metadataKey'];
        }
    }

    return subtypeMetadataList;
}
"""
      * def cleanupPayload =
"""
function(payload, defaults) {
    var keys = ['externalSignatureConfig', 'multiDocuments', 'secureMailServerId', 'sealCertificateId', 'subtypeLayerRequestList', 'subtypeMetadataList', 'workflowSelectionScript'];
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

        * def typeId = api_v1.type.getIdByName(tenantId, type)
        * def defaults =
"""
{
    "annotationsAllowed": false,
    "creationPermittedDeskIds": null,
    "creationWorkflowId": null,
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
    "subtypeMetadataList": [],
    "validationWorkflowId": "",
    "workflowSelectionScript": ""
}
"""

        * def payload = karate.merge(defaults, __row)
        * payload['creationPermittedDeskIds'] = utils.isEmpty(payload['creationPermittedDeskIds']) ? null : api_v1.desk.getAllIdsByNames(tenantId, payload['creationPermittedDeskIds'])
        * payload['creationWorkflowId'] = utils.isEmpty(payload['creationWorkflowId']) ? null : api_v1.workflow.getKeyByName(tenantId, payload['creationWorkflowId'])
        * payload['description'] = utils.isEmpty(payload['description']) ? payload['name'] : payload['description']
        * payload['externalSignatureConfigId'] = utils.isEmpty(payload['externalSignatureConfigId']) ? null : api_v1.externalSignature.getIdByName(tenantId, payload['externalSignatureConfigId'])
        * payload['sealCertificateId'] = utils.isEmpty(payload['sealCertificateId']) ? null : api_v1.sealCertificate.getIdByName(tenantId, payload['sealCertificateId'])
        * payload['secureMailServerId'] = utils.isEmpty(payload['secureMailServerId']) ? null : api_v1.secureMailServer.getIdByName(tenantId, payload['secureMailServerId'])
        * payload['subtypeLayerList'] = utils.isEmpty(payload['subtypeLayerList']) ? [] : prepareSubtypeLayerList(tenantId, payload['subtypeLayerList'])
        * payload['subtypeMetadataList'] = replaceMetadataKeyById(tenantId, payload['subtypeMetadataList'])
        * payload['validationWorkflowId'] = utils.isEmpty(payload['validationWorkflowId']) ? null : api_v1.workflow.getKeyByName(tenantId, payload['validationWorkflowId'])
        * payload['workflowSelectionScript'] = utils.isEmpty(payload['workflowSelectionScript']) ? '' : karate.readAsString(payload['workflowSelectionScript'])

        * def payload = cleanupPayload(payload, defaults);

        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/typology/type/', typeId, '/subtype'
            And header Accept = 'application/json'
            And request payload
        When method POST
        Then status 201