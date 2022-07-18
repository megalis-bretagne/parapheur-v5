@karate-function @ignore
Feature: IP v.4 REST type lib

    Scenario: Create type
        * def payload =
"""
{
  "isNew": true,
  "tdtOverride": "false",
  "sousTypes": [],
  "tdtNom": "pas de TdT",
  "tdtProtocole": "#(__row.protocol)",
  "sigLocation": "#(__row.location)",
  "sigPostalCode": "#(__row.postalCode)",
  "id": "#(__row.name)",
  "desc": "#(__row.description)",
  "sigFormat": "#(__row.format)"
}
"""
        Given url baseUrl
            And path "/iparapheur/proxy/alfresco/parapheur/types/" + encodeURI(__arg.name)
            And header Accept = "application/json"
            And request payload
        When method POST
        Then status 200
            And match response == ""
