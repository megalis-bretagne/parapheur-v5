@karate-function @ignore
Feature: IP v.4 REST folder lib

    Scenario: Signature placement
        * def defaults = {"x":0,"y":"0","width":100,"height":100, "page":1}
        * def position = karate.merge(defaults, __arg.positions)

        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/dossiers/" + __arg.folder.id + "/" + __arg.document.id + "/customSignature"
        * header Accept = "application/json"
        * request position
        * method POST
        * status 200
        * match response == ""
