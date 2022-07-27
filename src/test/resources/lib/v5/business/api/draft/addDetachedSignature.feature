@karate-function @ignore
Feature: IP v.5 REST draft lib

    Scenario: Send draft folder detached signature
        Given url baseUrl
            And path '/api/v1/tenant/' + __arg.tenant.id + '/folder/' + __arg.folder.id + '/document/' + __arg.document.id + '/detachedSignature'
            And header Accept = 'application/json'
            And multipart file file = { read: '#(__arg.file)', 'contentType': "#(utils.file.mime(__arg.file))" }
            * karate.log(__arg.desktop.id)
            And multipart field deskId = __arg.desktop.id
        When method POST
        Then status 201
