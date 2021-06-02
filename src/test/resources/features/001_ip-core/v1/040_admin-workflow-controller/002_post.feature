@ip-core @api-v1 @karate-todo
Feature: POST /api/v1/admin/tenant/{tenantId}/workflowDefinition (Create a workflow definition)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def unique = 'tmp-' + utils.getUUID()
        # @todo
        * def uniqueRequestData =
"""
{
    "steps": [
        {
            "validators": [
                "#(deskId)"
            ],
            "validationMode": "SIMPLE",
            "name": "<type>",
            "type": "<type>",
            "parallelType": "OR"
        }
    ],
    "name": "<name>",
    "id": "#(key)",
    "key": "#(key)",
    "deploymentId": "#(key)"
}
"""

    @permissions @todo-all-types @proposal
    Scenario: Permissions - a user with an "ADMIN" role can create a "VISA" workflow and associate it to a desk in an existing tenant
        * api_v1.auth.login('cnoir', 'a123456')
        * def tenantId = api_v1.entity.getIdByName('Default tenant')
        * def deskId = api_v1.desk.getIdByName(tenantId, 'tmp-', true)
        * def name = 'tmp-' + utils.getUUID()
        * def key = name.toLowerCase().replace(/[^a-z0-9]/g, '_')

        Given url baseUrl
            And path '/api/v1/admin/tenant/', tenantId, '/workflowDefinition'
            And header Accept = 'application/json'
            And request
"""
{
    "steps": [
        {
            "validators": [
                "#(deskId)"
            ],
            "validationMode": "SIMPLE",
            "name": "#(name)",
            "type": "VISA",
            "parallelType": "OR"
        }
    ],
    "name": "#(name)",
    "id": "#(key)",
    "key": "#(key)",
    "deploymentId": "#(key)"
}
"""
        When method POST
        Then status 201
            And match response == ''
            # proposal: response body should be not null ?
            # And match $ == schemas.workflow.element
