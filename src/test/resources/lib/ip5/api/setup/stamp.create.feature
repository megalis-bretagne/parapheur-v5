@karate-function @ignore
Feature: Stamp setup lib

    Scenario: Create stamp
        * def tenantId = ip5.api.v1.entity.getIdByName(tenant)
        * def layerId = ip5.api.v1.layer.getIdByName(tenantId, layer)
        * payload['id'] = 'new_stamp_temp_id'

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + tenantId + '/layer/' + layerId + '/stamp'
            And header Accept = 'application/json'
            And multipart file stamp = { 'value': '#(payload)', 'contentType': 'application/json', 'filename': 'blob' }
            And multipart file file = ip.utils.file.payload(file)
        When method POST
        Then status 201
