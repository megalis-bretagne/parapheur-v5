@karate-function @ignore
Feature: IP v.4 REST folder lib

    Scenario: Get available folder by name
        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/dossiers"
        * param asAdmin = "true"
        * param showOnlyCurrent = "false"
        * param showOnlyLate = "false"
        * param sousType = __arg.subtype
        * param title = __arg.name
        * param type = __arg.type
        * method GET
        * status 200
        * def jsonPath = "$[?(@.title=='" + __arg.name + "')]"
        * match karate.jsonPath(response, jsonPath).length != 0
        * def folder = karate.jsonPath(response, jsonPath)[0]
