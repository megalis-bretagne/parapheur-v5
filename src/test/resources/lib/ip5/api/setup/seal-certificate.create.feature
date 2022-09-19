@karate-function @ignore
Feature: Seal certificate setup lib

    Scenario: Create a seal certificate
        * def tenantId = ip5.api.v1.entity.getIdByName(tenant)

        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/sealCertificate'
            And header Accept = 'application/json'
            And multipart file file = { read: '#(path)', 'contentType': 'application/x-pkcs12' }
            And multipart field password = password
        When method POST
        Then status 201

        * eval if (image != '') karate.call('classpath:lib/ip5/api/setup/seal-certificate.image.create.feature', { tenantId: tenantId, sealCertificateId: response.id, path: image })
