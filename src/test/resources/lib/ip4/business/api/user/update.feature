@karate-function @ignore
Feature: IP v.4 REST user lib

    Scenario: Update user
        Given url baseUrl
            And path "/iparapheur/proxy/alfresco/parapheur/utilisateurs/" + __arg.id
            And header Accept = "application/json"
            And request __arg

        When method PUT
        Then status 200
