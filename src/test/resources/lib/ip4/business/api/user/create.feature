@karate-function @ignore
Feature: IP v.4 REST user lib

    Scenario: Create user
        Given url baseUrl
            And path "/iparapheur/proxy/alfresco/parapheur/utilisateurs"
            And header Accept = "application/json"
            And request __row

        When method POST
        Then status 200
            And match response == { "id": "#uuid" }
