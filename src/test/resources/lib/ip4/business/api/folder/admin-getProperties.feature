@karate-function @ignore
Feature: IP v.4 REST folder lib
  https://ip4.dom.local/iparapheur/proxy/alfresco/parapheur/dossiers/f3c993ae-7b55-4583-8a86-c4a0c87429e1/properties
  Scenario: Get available folder by name
    * url baseUrl
    * path "/iparapheur/proxy/alfresco/parapheur/dossiers/" + __arg.dossierId + "/properties"
    * method GET
    * status 200
