@ip-core @api-v1 @karate-todo
Feature: POST /api/admin/tenant/{tenantId}/typology/type (Create type)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')

    @permissions
    Scenario: Permissions - a user with an "ADMIN" role can create a "PADES" type with no protocol and associate it to an existing tenant
        * api_v1.auth.login('cnoir', 'a123456')
        * def tenantId = api_v1.entity.getIdByName('Default tenant')
        * def name = 'tmp-' + utils.getUUID()

        Given url baseUrl
            And path '/api/admin/tenant/', tenantId, '/typology/type'
            And header Accept = 'application/json'
            And request
"""
{
    'name': '#(name)',
    'description': 'Description',
    'signatureFormat': 'PADES',
    'signatureVisible': true
}
"""
        When method POST
        Then status 201
            And match $ == schemas.type.element
