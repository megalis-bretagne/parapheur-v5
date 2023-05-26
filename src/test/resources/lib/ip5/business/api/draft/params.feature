@karate-function @ignore
Feature: IP v.5 REST draft lib

    Scenario: ...
        * def tenant = ip5.business.api.tenant.getByName(__arg.tenant)
        * def desktop = ip5.business.api.desktop.getByName(tenant.id, __arg.desktop)

        Given url baseUrl
            And path "/api/v1/tenant/" + tenant.id + "/desk/" + desktop.id + "/types"
            And header Accept = "application/json"
        When method GET
        Then status 200
        * def type = karate.jsonPath(response, "$.content[?(@.name=='" + __arg.type + "')]")[0]

        Given url baseUrl
        And path "/api/v1/tenant/" + tenant.id + "/desk/" + desktop.id + "/types/" + type.id + "/subtypes"
        And header Accept = "application/json"
        When method GET
        Then status 200
        * def subtype = karate.jsonPath(response, "$.content[?(@.name=='" + __arg.subtype + "')]")[0]
        * def path = "/api/v1/tenant/" + tenant.id + "/desk/" + desktop.id + "/draft"

        # @todo: defaults + merge des champs nécessaires
        #* def defaults = { dueDate: null, metadata: {}, paperSignable: false, variableDesksIds: {}, visibility: "CONFIDENTIAL" }
        * def createFolderRequest =
"""
{
    "dueDate": null,
    "metadata": {},
    "name": "#(name)",
    "paperSignable": false,
    "subtypeId": "#(subtype.id)",
    "typeId": "#(type.id)",
    "variableDesksIds": {},
    "visibility": "CONFIDENTIAL"
}
"""
