@karate-function @ignore
Feature: User signature image setup lib

    Scenario: Create user signature image
        * def tenantId = api_v1.entity.getIdByName(tenant)
        * def userId = api_v1.user.getIdByEmail(tenantId, email)

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + tenantId + '/user/' + userId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: '#(path)', 'contentType': 'image/png' }
        When method POST
        Then status 201
