@karate-function @ignore
Feature: Seal certificate setup lib

  Scenario: Create a seal certificate
    * def tenantId = ip5.api.v1.entity.getIdByName(tenant)
    * def imgContentType = ip.utils.file.mime('#(path)')

    Given url baseUrl
    And path '/api/provisioning/v1/admin/tenant/', tenantId, '/sealCertificate'
    And header Accept = 'application/json'
    And multipart file certificateFile = { read: '#(path)', 'contentType': 'application/x-pkcs12' }
    And multipart field sealCertificate = { value: { password: '#(password)', name: 'e2e-test-cert', signatureImageContentId: ''}, contentType: 'application/json' }
    And multipart file imageFile = { read: '#(image)', 'contentType': '#(imgContentType)' }
    When method POST
    Then status 201

