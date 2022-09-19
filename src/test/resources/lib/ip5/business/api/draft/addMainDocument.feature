@karate-function @ignore
Feature: IP v.5 REST draft lib

    # @todo: main/annexe -> 1 bool
    Scenario: Add main document to draft folder
        Given url baseUrl
            And path '/api/v1/tenant/' + __arg.tenant.id + '/folder/' + __arg.draft.id + '/document/'
            And header Accept = 'application/json'
            And multipart file file = { read: '#(__arg.file)', 'contentType': "#(ip.utils.file.mime(__arg.file))" }
            And multipart field isMainDocument = true
            And multipart field name = "#(ip.utils.file.basename(__arg.file))"
        When method POST
        Then status 201
