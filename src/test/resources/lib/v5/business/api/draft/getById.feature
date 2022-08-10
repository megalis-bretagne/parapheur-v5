@karate-function @ignore
Feature: IP v.5 REST draft lib

    Scenario: Add main document to draft folder
        Given url baseUrl
            And path "/api/v1/tenant/" + __arg.tenant.id + "/folder/" + __arg.draft.id + "?asDeskId=" + __arg.desktop.id
            And header Accept = 'application/json'
        When method GET
        Then status 200
