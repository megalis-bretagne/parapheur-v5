@karate-function @ignore
Feature: IP v.5 REST folder lib

    Scenario: Signature placement
        * def defaults = {"pageRotation":0,"rectangleOrigin":"BOTTOM_LEFT","width":18,"height":18}
        * def position = karate.merge(defaults, __arg.position)

        * url baseUrl
        * path "/api/v1/tenant/" + __arg.tenant.id + "/folder/" + __arg.folder.id + "/document/" + __arg.document.id + "/signaturePlacement"
        * header Accept = "application/json"
        * request position
        * method POST
        * status 201
        * match response == ""
