@karate-function
Feature: Desk lib

  Scenario: Create temporary desk
    * def requestData =
"""
{
    "actionAllowed": true,
    "archivingAllowed": true,
    "associatedDeskIds":[],
    "supervisorIds": [],
    "delegationManagerIds": [],
    "availableSubtypeIdsList":[],
    "chainAllowed":true,
    "delegatingDesks":[],
    "filterableMetadataIds":[],
    "filterableSubtypeIdsList":[],
    "folderCreationAllowed": true,
    "linkedDeskboxIds":[],
    "ownerIds": [],
    "name": "#(name)",
    "shortName": "#(name)",
    "description": "#(description)",
    "parentDeskId": "#(parentDeskId)"
}
"""

    Given url baseUrl
        And path '/api/provisioning/v1/admin/tenant/', tenantId, '/desk'
        And header Accept = 'application/json'
        And request requestData
    When method POST
    Then status 201
