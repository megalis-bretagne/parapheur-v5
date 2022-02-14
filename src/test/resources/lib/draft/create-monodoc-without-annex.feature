@ignore
Feature:
    Scenario:
        Given url baseUrl
            And path path
            And header Accept = 'application/json'
            And multipart file draftFolderParams = { 'value': '#(draftFolderParams)', 'contentType': 'application/json' }
            And multipart file mainFiles = {  read: '#(mainFilePath)', contentType: utils.getMimeTypeFromFilename('#(mainFilePath)') }
        When method POST
        Then status 201
        # @todo: propager aux autres
        * eval if (mainFileDetachedPath !== null) karate.call('classpath:lib/setup/folder.document.detachedSignature.create.feature', { tenantId: tenantId, folderId: response.id, documentId: response.documentList[0].id, detachedSignature: mainFileDetachedPath })
