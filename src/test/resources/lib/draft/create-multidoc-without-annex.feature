@ignore
Feature:

    Scenario:
        Given url baseUrl
            And path path
            And header Accept = 'application/json'
            And multipart file draftFolderParams = { 'value': '#(draftFolderParams)', 'contentType': 'application/json' }
            # @fixme
            And multipart file mainFiles = {  read: '#(mainFilesPaths[0])', contentType: utils.getMimeTypeFromFilename('#(mainFilesPaths[0])') }
            And multipart file mainFiles = {  read: '#(mainFilesPaths[1])', contentType: utils.getMimeTypeFromFilename('#(mainFilesPaths[1])') }
        When method POST
        Then status 201
