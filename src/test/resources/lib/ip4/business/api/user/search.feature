@karate-function @ignore
Feature: IP v.4 REST user lib

    Scenario: Search user
        Given url baseUrl
            And path "/iparapheur/proxy/alfresco/parapheur/utilisateurs"
            And header Accept = "application/json"
            And param search = __arg.username

        When method GET
        Then status 200

        * def jsonPath = "$[?(@.username =~ /" + __arg.username + "@.*/i)]"
        * match karate.jsonPath(response, jsonPath) == '#[1]'
