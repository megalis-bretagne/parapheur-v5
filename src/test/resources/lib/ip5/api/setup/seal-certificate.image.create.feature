@karate-function @ignore
Feature: Seal certificate setup lib

    Scenario: Create a seal certificate image
        * def contentType = ip.utils.file.mime('#(path)')

        Given url baseUrl
            And path '/api/v1/admin/tenant/' + tenantId + '/sealCertificate/' + sealCertificateId + '/signatureImage'
            And header Accept = 'application/json'
            And multipart file file = { read: '#(path)', 'contentType': #(contentType) }
        When method POST
        Then status 201
