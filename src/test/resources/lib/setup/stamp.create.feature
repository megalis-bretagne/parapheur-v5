@karate-function @ignore
Feature: Stamp setup lib

    Scenario: Create stamp
        * def tenantId = api_v1.entity.getIdByName(tenant)
        * def layerId = api_v1.layer.getIdByName(tenantId, layer)
        * def getFilePayload =
"""
function(path) {
    if (path !== null) {
        path = { read: path, 'contentType': utils.getMimeTypeFromFilename(path) };
    }
    return path;
}
"""

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + tenantId + '/layer/' + layerId + '/stamp'
            And header Accept = 'application/json'
            And multipart file stamp = { 'value': '#(payload)', 'contentType': 'application/json', 'filename': 'blob' }
            And multipart file file = getFilePayload(file)
        When method POST
        Then status 201
