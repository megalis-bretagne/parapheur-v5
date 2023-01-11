@karate-function @ignore
Feature: IP v.4 REST folder lib

    Scenario: Get folder workflow by folder id
        * url baseUrl
        * path "/iparapheur/proxy/alfresco/parapheur/dossiers/" + __arg.folderId + "/circuit"
        * method GET
        * status 200
