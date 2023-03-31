@karate-function @ignore
Feature: Subtype setup lib

    Scenario: Create subtype

        * def tenantId = ip5.api.v1.entity.getIdByName(tenant)
        * def prepareSubtypeLayerList =
"""
function (tenantId, subtypeLayerList) {
    var result = [];
    for (var i = 0;i < subtypeLayerList.length;i++) {
        for (const [layer, association] of Object.entries(subtypeLayerList[i])) {
            var layerId = ip5.api.v1.layer.getIdByName(tenantId, layer);
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
            subtypeMetadataList[i]['metadataId'] = ip5.api.v1.metadata.getIdByKey(
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
        if (ip.utils.isEmpty(payload[key])) {
            delete payload[key];
        }
    }

    delete payload['tenant'];
    delete payload['type'];

    return payload;
}
"""

        * def typeId = ip5.api.v1.type.getIdByName(tenantId, type)
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
    "validationWorkflowId": "",
    "workflowSelectionScript": ""
}
"""

        * def payload = karate.merge(defaults, __row)
        * payload['creationPermittedDeskIds'] = ip.utils.isEmpty(payload['creationPermittedDeskIds']) ? null : ip5.api.v1.desk.getAllIdsByNames(tenantId, payload['creationPermittedDeskIds'])
        * payload['creationWorkflowId'] = ip.utils.isEmpty(payload['creationWorkflowId']) ? null : ip5.api.v1.workflow.getKeyByName(tenantId, payload['creationWorkflowId'])
        * payload['description'] = ip.utils.isEmpty(payload['description']) ? payload['name'] : payload['description']
        * payload['externalSignatureConfigId'] = ip.utils.isEmpty(payload['externalSignatureConfigId']) ? null : ip5.api.v1.externalSignature.getIdByName(tenantId, payload['externalSignatureConfigId'])
        * payload['sealCertificateId'] = ip.utils.isEmpty(payload['sealCertificateId']) ? null : ip5.api.v1.sealCertificate.getIdByName(tenantId, payload['sealCertificateId'])
        * payload['secureMailServerId'] = ip.utils.isEmpty(payload['secureMailServerId']) ? null : ip5.api.v1.secureMailServer.getIdByName(tenantId, payload['secureMailServerId'])
        * payload['subtypeLayerList'] = ip.utils.isEmpty(payload['subtypeLayerList']) ? [] : prepareSubtypeLayerList(tenantId, payload['subtypeLayerList'])
        * payload['subtypeMetadataList'] = replaceMetadataKeyById(tenantId, payload['subtypeMetadataList'])
        * payload['validationWorkflowId'] = ip.utils.isEmpty(payload['validationWorkflowId']) ? null : ip5.api.v1.workflow.getKeyByName(tenantId, payload['validationWorkflowId'])
        * payload['workflowSelectionScript'] = ip.utils.isEmpty(payload['workflowSelectionScript']) ? '' : karate.readAsString(payload['workflowSelectionScript'])

        * def payload = cleanupPayload(payload, defaults);

        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/typology/type/', typeId, '/subtype'
            And header Accept = 'application/json'
            And request payload
        When method POST
        Then status 201
