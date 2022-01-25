@ignore
Feature:
    Scenario:
        Given url baseUrl
          And path path
          And header Accept = 'application/json'
          And multipart file draftFolderParams = { 'value': '#(draftFolderParams)', 'contentType': 'application/json' }
          And multipart file mainFiles = {  read: '#(mainFilePath)', contentType: utils.getMimeTypeFromFilename('#(mainFilePath)') }
          And multipart file annexeFiles = {  read: '#(annexFilePath)', contentType: utils.getMimeTypeFromFilename('#(annexFilePath)') }
        When method POST
        Then status 201
