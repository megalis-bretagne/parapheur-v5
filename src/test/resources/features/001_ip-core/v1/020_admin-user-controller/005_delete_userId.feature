@ip-core @api-v1
Feature: DELETE /api/admin/tenant/{tenantId}/user/{userId} (Delete user)

    Background:
        * api_v1.auth.login('user', 'password')
        * def existingTenantId = api_v1.entity.getIdByName('Default tenant')
        * def nonExistingTenantId = api_v1.entity.getNonExistingId()
        * def existingUserId = api_v1.user.createTemporary(existingTenantId)
        * def nonExistingUserId = api_v1.user.getNonExistingId()
        * def userData = api_v1.user.getById(existingTenantId, existingUserId)

    @permissions
    Scenario: Permissions - a user with an "ADMIN" role can delete an existing user from an existing tenant
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status 204

    @permissions
    Scenario: Permissions - a user with an "ADMIN" role cannot delete an existing user from a non-existing tenant
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status 404

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with an "ADMIN" role cannot delete a non-existing user from an existing tenant
        * api_v1.auth.login('cnoir', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status 404

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with a "FUNCTIONAL_ADMIN" role cannot delete an existing user from an existing tenant
        * api_v1.auth.login('ablanc', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with a "FUNCTIONAL_ADMIN" role cannot delete an existing user from a non-existing tenant
        * api_v1.auth.login('ablanc', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with a "FUNCTIONAL_ADMIN" role cannot delete a non-existing user from an existing tenant
        * api_v1.auth.login('ablanc', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with a "NONE" role cannot delete an existing user from an existing tenant
        * api_v1.auth.login('ltransparent', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with a "NONE" role cannot delete an existing user from a non-existing tenant
        * api_v1.auth.login('ltransparent', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - a user with a "NONE" role cannot delete a non-existing user from an existing tenant
        * api_v1.auth.login('ltransparent', 'a123456')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status 403

    @permissions @fixme-ip-core
    Scenario: Permissions - an unauthenticated user cannot delete an existing user from an existing tenant
        * api_v1.auth.login('', '')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status 401

    @permissions @fixme-ip-core
    Scenario: Permissions - an unauthenticated user cannot delete an existing user from a non-existing tenant
        * api_v1.auth.login('', '')

        Given url baseUrl
            And path '/api/admin/tenant/', nonExistingTenantId, '/user/', existingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status 401

    @permissions @fixme-ip-core
    Scenario: Permissions - an unauthenticated user cannot delete a non-existing user from an existing tenant
        * api_v1.auth.login('', '')

        Given url baseUrl
            And path '/api/admin/tenant/', existingTenantId, '/user/', nonExistingUserId
            And header Accept = 'application/json'
        When method DELETE
        Then status 401
