@karate-function @ignore
Feature: IP v.4 REST subtype lib

    Scenario: Create subtype
        * def payload =
"""
{
  "calques": [],
  "calquesAnnexes": [],
  "circuit": "#(__arg.workflow)",
  "desc": "#(__arg.description)",
  "digitalSignatureMandatory": "true",
  "groups": [],
  "groupsFilters": [],
  "id": "#(__arg.name)",
  "isNew": true,
  "metadatas": [],
  "multiDocument": "#(__arg.multidoc)",
  "parapheurs": [],
  "parapheursFilters": [],
  "parent": "#(__arg.type)",
  "visibility": "public",
  "visibilityFilter": "public",
}
"""
      * if (__arg.hasOwnProperty('cachet') && __arg.cachet !== null) payload["cachetCertificate"] = (ip4.business.api.seal.getByName(__arg.cachet)).id
      * if (__arg.hasOwnProperty('isCachetAuto') && __arg.isCachetAuto !== null) payload["isCachetAuto"] = __arg.isCachetAuto
      * if (__arg.hasOwnProperty('mailsec') && __arg.mailsec !== null) payload["pastellMailsec"] = (ip4.business.api.pastellConnector.getByName(__arg.mailsec)).id
      * if (__arg.hasOwnProperty('metadatas') && __arg.metadatas !== null) payload["metadatas"] = __arg.metadatas

      * if (__arg.parapheurs !== []) payload["parapheurs"] = ip4.business.api.desktop.getAllIdsByName(__arg.parapheurs)
      * if (__arg.parapheurs !== []) payload["visibility"] = "private"

      Given url baseUrl
            And path "/iparapheur/proxy/alfresco/parapheur/types/" + encodeURI(__arg.type) + "/" + encodeURI(__arg.name)
            And header Accept = "application/json"
            And request payload
        When method POST
        Then status 200
            And match response == ""
