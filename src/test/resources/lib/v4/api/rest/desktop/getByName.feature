@karate-function @ignore
Feature: IP v.4 REST desktop lib

    # @todo: function
    # v4.api.rest.desktop.getIdByName(name)
    Scenario: Get available desktop by name
        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/bureaux"
        * param asAdmin = __arg.asAdmin
        * method GET
        * status 200
        * def jsonPath = "$[?(@.name=='" + __arg.name + "')]"
        * match karate.jsonPath(response, jsonPath) == '#[1]'
        * def desktop = karate.jsonPath(response, jsonPath)[0]
