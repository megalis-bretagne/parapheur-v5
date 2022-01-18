@ignore
Feature:
    Scenario:
        Given url baseUrl
          And path path
          And header Accept = 'application/json'
          And multipart file draftFolderParams = { 'value': '#(draftFolderParams)', 'contentType': 'application/json' }
          And multipart file mainFiles = {  read: '#(mainFilePath)' }
          And multipart file annexeFiles = {  read: '#(annexFilePath)' }
        When method POST
        Then status 201
