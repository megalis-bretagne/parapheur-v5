@karate-function @ignore
Feature: Seal certificate setup lib

    Scenario: Create a seal certificate image
        Given url baseUrl
            And path '/api/v1/admin/tenant/' + tenantId + '/sealCertificate/' + sealCertificateId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: '#(path)', 'contentType': utils.getMimeTypeFromFilename('#(path)') }
        When method POST
        Then status 201
