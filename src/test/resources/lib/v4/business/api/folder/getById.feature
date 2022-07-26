@karate-function @ignore
Feature: IP v.4 REST folder lib

    Scenario: Get (and "read") available folder by id
        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/dossiers/" + __arg.folderId + "?bureauCourant=" + __arg.deskId
        * method GET
        * status 200
