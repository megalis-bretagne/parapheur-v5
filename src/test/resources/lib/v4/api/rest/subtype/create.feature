@karate-function @ignore
Feature: IP v.4 REST subtype lib

    Scenario: Create subtype
        * def payload =
"""
{
  "isNew": true,
  "parent": "#(__arg.type)",
  "parapheurs": [],
  "parapheursFilters": [],
  "groupsFilters": [],
  "groups": [],
  "calques": [],
  "calquesAnnexes": [],
  "metadatas": [],
  "visibility": "public",
  "visibilityFilter": "public",
  "digitalSignatureMandatory": "true",
  "id": "#(__arg.name)",
  "desc": "#(__arg.description)",
  "circuit": "#(__arg.workflow)",
  "multiDocument": "#(__arg.multidoc)",
}
"""
        Given url baseUrl
            And path "/iparapheur/proxy/alfresco/parapheur/types/" + encodeURI(__arg.type) + "/" + encodeURI(__arg.name)
            And header Accept = "application/json"
            And request payload
        When method POST
        Then status 200
            And match response == ""
