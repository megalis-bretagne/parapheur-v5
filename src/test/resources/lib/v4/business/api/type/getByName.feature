@karate-function @ignore
Feature: IP v.4 REST type lib

    Scenario: Get available type by name
        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/types"
        * param asAdmin = __arg.asAdmin
        * method GET
        * status 200
        * def jsonPath = "$[?(@.id=='" + __arg.name + "')]"
        * match karate.jsonPath(response, jsonPath) == '#[1]'
        * def type = karate.jsonPath(response, jsonPath)[0]
