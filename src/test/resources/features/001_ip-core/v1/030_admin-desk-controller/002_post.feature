@ip-core @api-v1
Feature: POST /api/admin/tenant/{tenantId}/desk (Create a new desk)

    Background:
    * api_v1.auth.login('user', 'password')
    * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
    * def nonExistingTenantId = api_v1.entity.getNonExistingId()
    * def unique = 'tmp-' + utils.getUUID()
    * def uniqueRequestData =
"""
{
    'name': '#(unique)',
    'description': '#(unique)',
    'parentDeskId': null
}
"""

    @permissions
    Scenario: Permissions - a user with an "ADMIN" role can create a desk in an existing tenant
        * api_v1.auth.login('cnoir', 'a123456')
        * def tenantId = api_v1.entity.getIdByName('Default tenant')
        * def description = 'Bureau ' + unique

        Given url baseUrl
            And path '/api/admin/tenant/', tenantId, '/desk'
            And header Accept = 'application/json'
            And request
"""
{
    'name': '#(unique)',
    'description': '#(description)',
    'parentDeskId': null
}
"""
        When method POST
        Then status 201
            And match $ == schemas.desk.element
            And match $.name == unique
            And match $.description == description

    @data-validation @fixme-ip-core @proposal
    Scenario: Data validation - a user with an "ADMIN" role cannot create a desk with empty data
        * api_v1.auth.login('cnoir', 'a123456')
        * def tenantId = api_v1.entity.getIdByName('Default tenant')

        Given url baseUrl
            And path '/api/admin/tenant/', tenantId, '/desk'
            And header Accept = 'application/json'
            And request
"""
{
    'name': '',
    'description': '',
    'parentDeskId': null
}
"""
        When method POST
        Then status 400
