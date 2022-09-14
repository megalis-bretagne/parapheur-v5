@karate-function @ignore
Feature: IP v.4 REST workflow lib

    Scenario: Create workflow
        * def desk = v4.business.api.desktop.getByName(__arg.desktop, true)
        * def payload =
"""
{
    "aclGroupes": [],
    "aclParapheurs": [],
    "editable": true,
    "isUsed": false,
    "etapes": [
        {
            "transition": "PARAPHEUR",
            "index": 0,
            "actionDemandee": "#(action)",
            "listeNotification": [],
            "listeMetadatas": [],
            "listeMetadatasRefus": [],
            "parapheur": "#(desk.id)",
            "parapheurName": "#(desk.name)"
        },
        {
            "actionDemandee": "ARCHIVAGE",
            "listeNotification": [],
            "transition": "EMETTEUR"
        }
    ],
    "isPublic": false,
    "name": "#(name)"
}
"""
        Given url baseUrl
            And path "/iparapheur/proxy/alfresco/parapheur/circuits"
            And header Accept = "application/json"
            And request payload
        When method POST
        Then status 200
            And match response == { "id": "#uuid" }
