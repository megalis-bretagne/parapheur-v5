@karate-function @ignore
Feature: IP v.5 REST folder lib

    Scenario: Get full folder
        * url baseUrl
        * path "/api/v1/tenant/" + __arg.tenantId + "/folder/" + __arg.folderId + "?asDeskId=" + __arg.desktopId
        * method GET
        * status 200
        * copy folder = response
