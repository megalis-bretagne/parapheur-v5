@karate-function @ignore
Feature: IP v.4 REST desktop lib

    Scenario: Create desktop
        * def searchUsers =
"""
function (users) {
    var idx, rv, result = [];
    for (idx = 0 ; idx < users.length ; idx++) {
        rv = karate.call('classpath:lib/ip4/business/api/user/getSingle.feature', { search: users[idx] });
        result.push(rv.user);
    }
    return result;
}
"""
        * def defaults =
"""
{
  "delegations-possibles": [],
  "metadatas-visibility": [],
  "proprietaires": [],
  "secretaires": [],
  "description": "",
  "profondeur": 0,
  "name": "",
  "title": ""
}
"""
        * def payload = karate.merge(defaults, __row)
        * payload["proprietaires"] = searchUsers(__row["proprietaires"])
        * payload["secretaires"] = searchUsers(__row["secretaires"])

        Given url baseUrl
            And path "/iparapheur/proxy/alfresco/parapheur/bureaux"
            And header Accept = "application/json"
            And request payload
        When method POST
        Then status 200
            And match response == { "id": "#uuid" }

        # @todo ?
        # PUT /iparapheur/proxy/alfresco/parapheur/delegations/1178e01a-0afd-4853-81ad-e5fb34867e7b
        # {}
