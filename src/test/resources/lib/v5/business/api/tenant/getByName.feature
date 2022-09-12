@karate-function @ignore
Feature: IP v.5 REST tenant lib

    Scenario: Get available tenant by name
        * url baseUrl
        * path "/api/v1/tenant"
        * param page = 0
        * param size = 1000
        * param sort = "name,ASC"
        * param withAdminRights = __arg.withAdminRights
        * method GET
        * status 200
        * def jsonPath = "$.content[?(@.name=='" + __arg.name + "')]"
        * match karate.jsonPath(response, jsonPath).length != 0
        * def tenant = karate.jsonPath(response, jsonPath)[0]
