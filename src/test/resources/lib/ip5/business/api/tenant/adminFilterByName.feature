@karate-function @ignore
Feature: IP v.5 REST tenant lib

    Scenario: Get available tenant by name
        * url baseUrl
        * path "/api/v1/admin/tenant"
        * param page = 0
        * param searchTerm = __arg.name
        * param size = 10
        * param sort = "name,ASC"
        * method GET
        * status 200

        * match karate.jsonPath(response, "$.content").length == 1
        * match karate.jsonPath(response, "$.content[0].name") == __arg.name
