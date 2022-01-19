@karate-function @ignore
Feature: Desk setup lib

    # @todo: habilitations, @see karate.merge
    Scenario: Create desk
        * def tenantId = api_v1.entity.getIdByName(tenant)
        * def userId = api_v1.user.getIdByEmail(tenantId, email)
        * def description = "Bureau " + name

        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/desk'
            And header Accept = 'application/json'
            And request
"""
{
    "actionAllowed": true,
    "archivingAllowed": true,
    "associatedDeskIdsList":[],
    "availableSubtypeIdsList":[],
    "chainAllowed":true,
    "delegatingDesks":[],
    "description": "#(description)",
    "filterableMetadataIdsList":[],
    "filterableSubtypeIdsList":[],
    "folderCreationAllowed": true,
    "linkedDeskboxIds":[],
    "name": "#(name)",
    "ownerUserIdsList": [
        "#(userId)"
    ],
    "parentDeskId": null,
    "shortName": "#(name)",
}
"""
            When method POST
            Then status 201
