@karate-function @ignore
Feature: IP v.5 REST desktop lib

    Scenario: Get available desktop by name
        * url baseUrl
        * path "/api/v1/currentUser/desks"
        * param page = 0
        * param pageSize = 250
        * method GET
        * status 200
        * def jsonPath = "$.data[?(@.tenantId=='" + __arg.tenantId + "')][?(@.name=='" + __arg.name + "')]"
        * match karate.jsonPath(response, jsonPath).length != 0
        * def desktop = karate.jsonPath(response, jsonPath)[0]
