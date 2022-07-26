@karate-function @ignore
Feature: IP v.4 REST folder lib

    Scenario: Get available folder by name
        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/dossiers"
        * param asc = "true"
        * param bureau = __arg.deskId
        * param corbeilleName = __arg.corbeilleName
        * param filter = '{"and":[{"or":[{"cm:title":"*' + __arg.name + '*"},{"cm:name":"*' + __arg.name + '*"}]},{"or":[]},{"or":[]}]}'
        * param metas = '{"metas":[]}'
        * param page = 0
        * param pageSize = 0
        * param pendingFile = 0
        * param skipped = 0
        * param sort = "cm:title"
        * method GET
        * status 200
        * def jsonPath = "$[?(@.title=='" + __arg.name + "')]"
        * match karate.jsonPath(response, jsonPath).length != 0
        * def folder = karate.jsonPath(response, jsonPath)[0]
