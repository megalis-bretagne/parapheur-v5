@karate-function @ignore
Feature: IP v.4 REST seal lib

    Scenario: Get available seal by name
        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/seals"
        #* param asAdmin = __arg.asAdmin
        * method GET
        * status 200
        * def jsonPath = "$[?(@.title=='" + __arg.name + "')]"
        * match karate.jsonPath(response, jsonPath) == '#[1]'
        * def seal = karate.jsonPath(response, jsonPath)[0]
