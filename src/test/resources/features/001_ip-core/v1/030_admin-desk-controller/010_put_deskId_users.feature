@ip-core @api-v1
Feature: PUT /api/admin/tenant/{tenantId}/desk/{deskId}/users (Add user to desk)

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
    Scenario: Permissions - a user with an "ADMIN" role can associate a desk to users
        * api_v1.auth.login('cnoir', 'a123456')
        * def tenantId = api_v1.entity.getIdByName('Default tenant')

        Given url baseUrl
        And path '/api/admin/tenant/', tenantId, '/desk'
        And header Accept = 'application/json'
        And request
"""
{
'name': '#(unique)',
'description': 'Bureau #(unique)',
'parentDeskId': null
}
"""
        When method POST
        Then status 201

      * def deskId = $.id
      * def userId = api_v1.user.getIdByEmail(tenantId, 'ltransparent@dom.local')

      Given url baseUrl
          And path '/api/admin/tenant/', tenantId, '/desk/', deskId, '/users'
          And header Accept = 'application/json'
          And request { "userIdList": ["#(userId)"] }
      When method PUT
      Then status 200
