@karate-function @ignore
Feature: Subtype setup lib

    Scenario: Create subtype
        #* pause(5)
        * def tenantId = api_v1.entity.getIdByName(tenant)
        * def typeId = api_v1.type.getIdByName(tenantId, type)
        * def defaults =
"""
{
    "annotationsAllowed": false,
    "creationPermittedDeskIds": null,
    "externalSignatureConfig": {},
    "externalSignatureConfigId": null,
    "filterableByDeskIds": null,
    "ipngTypeKeys": [],
    "name": "",
    "sealCertificateId": "",
    "secureMailServerId": "",
    "subtypeLayerRequestList": [],
    "subtypeMetadataList": [],
    "subtypeMetadataRequestList": [],
    "validationWorkflowId": "",
    "workflowSelectionScript": ""
}
"""
      * def isEmpty =
"""
function (value) {
    // https://stackoverflow.com/a/32108184
    var isEmptyObject = value && Object.keys(value).length === 0 && Object.getPrototypeOf(value) === Object.prototype;
    var isEmptyArray = Array.isArray(value) && value.length == 0;
    if (value == undefined || value == null || value == '' || isEmptyObject || value == []) {
        return true;
    }
    return false;
}
"""
        * def payload = karate.merge(defaults, __row)
        * payload['description'] = isEmpty(payload['description']) ? payload['name'] : payload['description']
        * payload['sealCertificateId'] = isEmpty(payload['sealCertificateId']) ? null : api_v1.sealCertificate.getIdByName(tenantId, payload['sealCertificateId'])
        * payload['secureMailServerId'] = isEmpty(payload['secureMailServerId']) ? null : api_v1.secureMailServer.getIdByName(tenantId, payload['secureMailServerId'])
        * payload['validationWorkflowId'] = isEmpty(payload['validationWorkflowId']) ? null : api_v1.workflow.getKeyByName(tenantId, payload['validationWorkflowId'])
        * payload['workflowSelectionScript'] = isEmpty(payload['workflowSelectionScript']) ? '' : karate.readAsString(payload['workflowSelectionScript'])
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
        if (isEmpty(payload[key])) {
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
