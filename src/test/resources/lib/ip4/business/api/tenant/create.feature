@karate-function @ignore
Feature: IP v.4 REST tenant lib

    Scenario: Create tenant
        * def defaults =
"""
{
  "title": "",
  "tenantDomain": "",
  "siren": "",
  "city": "",
  "country": "",
  "postalCode": "",
  "enabled": true,
  "isNew": true,
  "exist": false,
  "description": "",
  "modify": true,
  "password": ""
}
"""
        * def payload = karate.merge(defaults, __row)

        Given url baseUrl
            And path "/iparapheur/proxy/alfresco/parapheur/mc/" + encodeURI(payload["tenantDomain"])
            And header Accept = "application/json"
            And request payload
        When method POST
        Then status 200
            And match response == ""
