@ignore
Feature:

    Scenario:
        * def detachedSignatureContentType = utils.getMimeTypeFromFilename('#(detachedSignature)')

        Given url baseUrl
            And path '/api/v1/tenant/' + tenantId + '/folder/' + folderId + '/document/' + documentId + '/detachedSignature'
            And header Accept = 'application/json'
            And multipart file file = { read: '#(detachedSignature)', 'contentType': #(detachedSignatureContentType) }
        When method POST
        Then status 201
