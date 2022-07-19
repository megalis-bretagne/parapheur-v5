@karate-function @ignore
Feature: IP v.4 REST pastell-connector lib

    Scenario: Get available pastell-connector by name
        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/pastell/mailsec"
        # * param asAdmin = __arg.asAdmin
        * method GET
        * status 200
        * def jsonPath = "$[?(@.title=='" + __arg.name + "')]"
        * match karate.jsonPath(response, jsonPath) == '#[1]'
        * def pastellConnector = karate.jsonPath(response, jsonPath)[0]
