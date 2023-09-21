@karate-function @ignore
Feature: IP v.5 REST folder lib

    Scenario: Get available folder by name
        * url baseUrl
        * def upperCaseState = __arg.state.toUpperCase()
        * path "api/internal/tenant/" + __arg.tenantId + "/desk/" + __arg.deskId +"/search/" + karate.lowerCase(__arg.state)
        * param sort = "FOLDER_NAME,ASC"
        * param page = 0
        * param size = 1
        * request { state: "#(upperCaseState)", searchData: "#(__arg.name)" }
        * method POST
        * status 200
        * def jsonPath = "$.content[?(@.name=='" + __arg.name + "')]"
        * match karate.jsonPath(response, jsonPath).length != 0
        * def folder = karate.jsonPath(response, jsonPath)[0]
