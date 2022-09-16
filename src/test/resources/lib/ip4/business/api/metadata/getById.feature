@karate-function @ignore
Feature: IP v.4 REST metadata lib

    Scenario: Get available metadata by id
        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/metadonnees"
        * param asAdmin = __arg.asAdmin
        * method GET
        * status 200
        * def jsonPath = "$[?(@.id=='" + __arg.id + "')]"
        * match karate.jsonPath(response, jsonPath) == '#[1]'
        * def metadata = karate.jsonPath(response, jsonPath)[0]
        * karate.log(metadata)
