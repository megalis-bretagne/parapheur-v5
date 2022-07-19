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
  "metadatas": #(__arg.metadatas),
  "visibility": "public",
  "visibilityFilter": "public",
  "digitalSignatureMandatory": "true",
  "id": "#(__arg.name)",
  "desc": "#(__arg.description)",
  "circuit": "#(__arg.workflow)",
  "multiDocument": "#(__arg.multidoc)",
}
"""
      * if (__arg.cachet !== null) payload["cachetCertificate"] = (v4.api.rest.seal.getByName(__arg.cachet)).id
      * if (__arg.mailsec !== null) payload["pastellMailsec"] = (v4.api.rest.pastellConnector.getByName(__arg.mailsec)).id

      * if (__arg.parapheurs !== []) payload["parapheurs"] = v4.api.rest.desktop.getAllIdsByName(__arg.parapheurs)
      * if (__arg.parapheurs !== []) payload["visibility"] = "private"

      Given url baseUrl
            And path "/iparapheur/proxy/alfresco/parapheur/types/" + encodeURI(__arg.type) + "/" + encodeURI(__arg.name)
            And header Accept = "application/json"
            And request payload
        When method POST
        Then status 200
            And match response == ""
