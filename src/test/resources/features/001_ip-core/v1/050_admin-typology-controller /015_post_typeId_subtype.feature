@ip-core @api-v1 @karate-todo
Feature: POST /api/v1/admin/tenant/{tenantId}/typology/type/{typeId}/subtype (Create subtype)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')

    @permissions @fixme-karate
    Scenario: Permissions - a user with an "TENANT_ADMIN" role can create a ...@fixme... and associate it to an existing tenant
        * api_v1.auth.login('cnoir', 'a123456')
        * def tenantId = api_v1.entity.getIdByName('Default tenant')
        * def workflowKey = api_v1.workflow.getKeyByName(tenantId, 'tmp-', true)
        * def typeId = api_v1.type.getIdByName(tenantId, 'tmp-', true)
        * def name = 'tmp-' + utils.getUUID()

        Given url baseUrl
        And path '/api/v1/admin/tenant/', tenantId, 'typology/type/', typeId, '/subtype'
            And header Accept = 'application/json'
            And request
"""
{
    "name" : "#(name)",
    "tenantId" : "#(tenantId)",
    "creationWorkflowId" : null,
    "validationWorkflowId" : "#(workflowKey)",
    "description" : "Description",
    "isDigitalSignatureMandatory" : true
}
"""
        When method POST
        Then status 201
            #And match $ == schemas.subtype.element
            And match response == ''
