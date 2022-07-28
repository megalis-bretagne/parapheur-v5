@karate-function @ignore
Feature: IP v.5 REST draft lib

    Scenario: ...
        Given url baseUrl
            And path params.path
            And header Accept = "application/json"
            And multipart file draftFolderParams = { "value": "#(__arg.params.draftFolderParams)", "contentType": "application/json" }
            And multipart file mainFiles = { read: "#(commonpath.get(__arg.mainFiles[0].file))", contentType: "#(utils.file.mime(commonpath.get(__arg.mainFiles[0].file)))" }
        When method POST
        Then status 201
        * copy folder = response
