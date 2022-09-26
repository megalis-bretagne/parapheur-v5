@karate-function @ignore
Feature: IP v.5 REST folder lib

    Scenario: Get available folder by name
        * url baseUrl
        * path "/api/v1/tenant/" + __arg.tenantId + "/desk/" + __arg.deskId +"/search/" + karate.lowerCase(__arg.state)
        * param asc = true
        * param sortBy = "FOLDER_NAME"
        * param page = 0
        * param size = 1
        * def upperCaseState = __arg.state.toUpperCase()
        * request { state: "#(upperCaseState)", searchData: "#(__arg.name)" }
        * method POST
        * status 200
        * def jsonPath = "$.data[?(@.name=='" + __arg.name + "')]"
        * match karate.jsonPath(response, jsonPath).length != 0
        * def folder = karate.jsonPath(response, jsonPath)[0]