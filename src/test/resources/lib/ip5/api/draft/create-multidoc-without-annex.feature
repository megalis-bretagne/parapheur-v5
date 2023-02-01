@ignore
Feature:

    Scenario:
        * def mainFilesContentTypes = []
        * mainFilesContentTypes[0] = ip.utils.file.mime(mainFilesPaths[0])
        * mainFilesContentTypes[1] = ip.utils.file.mime(mainFilesPaths[1])

        Given url baseUrl
            And path path
            And header Accept = 'application/json'
            And multipart file createFolderRequest = { 'value': '#(createFolderRequest)', 'contentType': 'application/json' }
            # @fixme
            And multipart file mainFiles = {  read: '#(mainFilesPaths[0])', contentType: #(mainFilesContentTypes[0]) }
            And multipart file mainFiles = {  read: '#(mainFilesPaths[1])', contentType: #(mainFilesContentTypes[1]) }
        When method POST
        Then status 201
        # @todo: Ajout des signatures détachées le cas échéant
