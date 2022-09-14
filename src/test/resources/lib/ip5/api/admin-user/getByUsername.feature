@karate-function @ignore
Feature: IP v.5 REST admin-user lib

    Scenario: Get available user by name
        * url baseUrl
        * path "/api/v1/admin/user"
        * param page = 0
        * param searchTerm = __arg.username
        * param size = 10
        * param sort = "LAST_NAME,ASC"
        * method GET
        * status 200

        * match karate.jsonPath(response, "$.data").length == 1
        * match karate.jsonPath(response, "$.data[0].userName") == __arg.username
