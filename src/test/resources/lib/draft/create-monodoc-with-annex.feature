@ignore
Feature:
    Scenario:
      * def mainFileContentType = utils.getMimeTypeFromFilename(mainFilePath)
      * def annexFileContentType = utils.getMimeTypeFromFilename(annexFilePath)

        Given url baseUrl
          And path path
          And header Accept = 'application/json'
          And multipart file draftFolderParams = { 'value': '#(draftFolderParams)', 'contentType': 'application/json' }
          And multipart file mainFiles = {  read: '#(mainFilePath)', contentType: #(mainFileContentType) }
          And multipart file annexeFiles = {  read: '#(annexFilePath)', contentType: #(annexFileContentType) }
        When method POST
        Then status 201
        # Ajout de la signature détachée le cas échéant
      * eval if (mainFileDetachedPath !== null) karate.call('classpath:lib/setup/folder.document.detachedSignature.create.feature', { tenantId: tenantId, folderId: response.id, deskId: deskId, documentId: utils.getDraftDocumentId(response, mainFilePath), detachedSignature: mainFileDetachedPath })
