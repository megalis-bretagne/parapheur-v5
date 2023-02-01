@ignore
Feature:
    Scenario:
      * def mainFileContentType = ip.utils.file.mime(mainFilePath)
      * def annexFileContentType = ip.utils.file.mime(annexFilePath)

        Given url baseUrl
          And path path
          And header Accept = 'application/json'
          And multipart file createFolderRequest = { 'value': '#(createFolderRequest)', 'contentType': 'application/json' }
          And multipart file mainFiles = {  read: '#(mainFilePath)', contentType: #(mainFileContentType) }
          And multipart file annexeFiles = {  read: '#(annexFilePath)', contentType: #(annexFileContentType) }
        When method POST
        Then status 201
        # Ajout de la signature détachée le cas échéant
      * eval if (mainFileDetachedPath !== null) karate.call('classpath:lib/ip5/api/setup/folder.document.detachedSignature.create.feature', { tenantId: tenantId, folderId: response.id, deskId: deskId, documentId: ip5.utils.getDraftDocumentId(response, mainFilePath), detachedSignature: mainFileDetachedPath })
