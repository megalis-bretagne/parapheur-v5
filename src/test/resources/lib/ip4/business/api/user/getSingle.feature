@karate-function @ignore
Feature: IP v.4 REST user lib

    Scenario: Get user
        Given url baseUrl
            And path "/iparapheur/proxy/alfresco/parapheur/utilisateurs?search=" + __arg.search
            And header Accept = "application/json"
        When method GET
            And status 200
        * def jsonPath = "$[?(@.username=='" + __arg.name + "')]"
        * match response == '#[1]'
        * def user = response[0]

